import 'dart:collection';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttersampleapp/core/storage/i_preference.dart';
import 'package:fluttersampleapp/core/storage/preference_keys.dart';
import 'package:fluttersampleapp/core/utils/common_functions.dart';
import 'package:fluttersampleapp/features/authentication/data/models/login_response.dart';
import 'package:fluttersampleapp/features/authentication/domain/usecase/authentication_usecase.dart';
import 'package:fluttersampleapp/main.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.iPreference, required this.authenticationUseCase})
    : super(AuthState().init()) {
    _loginRequestEvent();
  }

  IPreference iPreference;
  AuthenticationUseCase authenticationUseCase;

  TextEditingController usernameEditController = TextEditingController();
  TextEditingController passwordEditController = TextEditingController();

  Map<String, dynamic> _clientInformation = {};
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  LoginResponse? loginResponse;

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

  void _loginRequestEvent() {
    on<LoginRequestEvent>((event, emit) async {
      hideKeyBoard(context: event.context);
      emit(LoadingState());
      final res = await authenticationUseCase(
        HashMap.from({
          'username': event.username,
          'password': event.password,
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
          preferenceInfoModel.username = event.username;
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
            value: event.username,
          );
          iPreference.setPreferenceValue(
            preferenceKey: PreferenceKey.prefPassword,
            value: event.password,
          );
          iPreference.setPreferenceValue(
            preferenceKey: PreferenceKey.prefFullName,
            value: loginResponse?.fullNameAr ?? '',
          );
          // AutoRouter.of(event.context).replaceAll([const DashboardRoute()]);
          emit(SuccessState());
          return r;
        },
      );
    });
  }
}
