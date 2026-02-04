import 'dart:collection';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttersampleapp/core/routes/app_router.gr.dart';
import 'package:fluttersampleapp/core/storage/i_preference.dart';
import 'package:fluttersampleapp/core/storage/preference_keys.dart';
import 'package:fluttersampleapp/core/utils/common_functions.dart';
import 'package:fluttersampleapp/features/authentication/data/models/login_response.dart';
import 'package:fluttersampleapp/features/authentication/domain/usecase/authentication_usecase.dart';
import 'package:fluttersampleapp/main.dart';
import 'package:local_auth/local_auth.dart';

import 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({
    required this.iPreference,
    required this.authenticationUseCase,
  }) : super(AuthenticationState().init());

  IPreference iPreference;
  AuthenticationUseCase authenticationUseCase;

  TextEditingController usernameEditController = TextEditingController();
  TextEditingController passwordEditController = TextEditingController();

  Map<String, dynamic> _clientInformation = {};
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final LocalAuthentication localAuthentication = LocalAuthentication();

  bool isBiometricSupported = false;
  bool isAlreadyAuthenticatedForBiometric = false;

  LoginResponse? loginResponse;

  Future<void> navigateScreen({required BuildContext context}) async {
    String customerId = await iPreference.getPreferenceValue(
      preferenceKey: PreferenceKey.prefToken,
      defaultValue: '',
    );
    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) {
      if (customerId.isEmpty) {
        AutoRouter.of(context).replaceAll([const LoginRoute()]);
      } else {
        // AutoRouter.of(context).replaceAll([const HomeRoute()]);
        AutoRouter.of(context).replaceAll([const LoginRoute()]);
      }
    }
  }

  Future<void> getClientDeviceInformation() async {
    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo val = await deviceInfoPlugin.androidInfo;
        _clientInformation = {
          "agent": "Mobile",
          "client": val.brand,
          "os": "ANDROID ${val.version.release}",
          "release": "DJS1.0",
        };
      } else if (Platform.isIOS) {
        final IosDeviceInfo val = await deviceInfoPlugin.iosInfo;
        _clientInformation = {
          "agent": "Mobile",
          "client": val.model,
          "os": "IOS ${Platform.operatingSystemVersion}",
          "release": "DJS1.0",
        };
      }
    } on PlatformException {
      _clientInformation = <String, dynamic>{
        "agent": "Mobile",
        "client": "N/A",
        "os": "N/A",
        "release": "DJS1.0",
      };
    }
  }

  /* this function initialize biometric authentication stuff */
  initBiometric() {
    isAlreadyAuthenticatedForBiometric =
        (preferenceInfoModel.username ?? '').isNotEmpty;
    localAuthentication.isDeviceSupported().then((bool isSupported) {
      isBiometricSupported = isSupported;
      logcat('is allow biometric login = $isAlreadyAuthenticatedForBiometric');
      logcat('is supported biometric login = $isBiometricSupported');
      emit(AuthenticationState().init());
    });
  }

  /* this function will authenticate biometric fingerprint and if return true/authenticated then it will call login api */
  Future<void> authenticateBiometric(BuildContext context) async {
    bool authenticated = false;
    try {
      authenticated = await localAuthentication.authenticate(
        localizedReason:
            'Enter phone screen lock pattern, pin, password or fingerprint.',
        options: const AuthenticationOptions(stickyAuth: true),
      );
      if (authenticated && context.mounted) {
        String prefUsername = preferenceInfoModel.username ?? '';
        String prefPassword = preferenceInfoModel.password ?? '';
        apiCallLogin(
          context: context,
          username: prefUsername,
          password: prefPassword,
        );
      }
    } on PlatformException catch (e) {
      logcat('Biometrics exception = $e');
      return;
    }
  }

  void apiCallLogin({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    hideKeyBoard(context: context);
    emit(LoadingState());
    final res = await authenticationUseCase(
      HashMap.from({
        'username': username,
        'password': password,
        'deviceToken': preferenceInfoModel.fcmToken ?? '',
        'clientInformation': HashMap.from(_clientInformation),
      }),
    );

    logcat('api response login = ${res.toString()} ');

    res.fold(
      (l) {
        emit(FailureState(msg: l.errorMessage));
        return l;
      },
      (r) async {
        loginResponse = r;
        preferenceInfoModel.token = loginResponse?.token;
        preferenceInfoModel.tokenRefresh = loginResponse?.tokenRefresh;
        preferenceInfoModel.username = username;
        preferenceInfoModel.fullName = loginResponse?.fullNameAr;
        iPreference.setPreferenceValue(
          preferenceKey: PreferenceKey.prefToken,
          value: loginResponse?.token ?? '',
        );
        iPreference.setPreferenceValue(
          preferenceKey: PreferenceKey.prefTokenRefresh,
          value: loginResponse?.tokenRefresh ?? '',
        );
        iPreference.setPreferenceValue(
          preferenceKey: PreferenceKey.prefUsername,
          value: username,
        );
        iPreference.setPreferenceValue(
          preferenceKey: PreferenceKey.prefPassword,
          value: password,
        );
        iPreference.setPreferenceValue(
          preferenceKey: PreferenceKey.prefFullName,
          value: loginResponse?.fullNameAr ?? '',
        );
        // AutoRouter.of(context).replaceAll([const DashboardRoute()]);
        emit(SuccessState());
        return r;
      },
    );
  }
}
