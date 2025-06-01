import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttersampleapp/core/utils/app_colors.dart';
import 'package:fluttersampleapp/core/utils/app_extensions.dart';
import 'package:fluttersampleapp/core/utils/app_size_constants.dart';
import 'package:fluttersampleapp/core/utils/form_validators.dart';
import 'package:fluttersampleapp/core/utils/image_constants.dart';
import 'package:fluttersampleapp/core/widgets/common_button_widget.dart';
import 'package:fluttersampleapp/core/utils/common_functions.dart';
import 'package:fluttersampleapp/core/widgets/common_icon_button_widget.dart';
import 'package:fluttersampleapp/core/widgets/custom_text_form_field.dart';
import 'package:fluttersampleapp/features/authentication/dependency/auth_get_it.dart';
import 'package:fluttersampleapp/features/authentication/presentation/cubits/authentication_cubit.dart';
import 'package:fluttersampleapp/features/authentication/presentation/cubits/authentication_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  late AuthenticationCubit _authenticationCubit;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _authenticationCubit = authGetIt.get<AuthenticationCubit>();
    _authenticationCubit.getClientDeviceInformation();
    _authenticationCubit.usernameEditController.text = 'test';
    _authenticationCubit.passwordEditController.text = 'test@123';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        _authenticationCubit.initBiometric();
        return _authenticationCubit;
      },
      child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is FailureState) {
            showAlertDialog(
                context: context,
                widget: Text('Show your common error dialog'));
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (MediaQuery.of(context).size.height * 0.1)
                            .toSizedBoxHeight,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: padding24, vertical: padding24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              'Login'.textWidget(
                                  color: colorBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSizeMedium),
                              _fieldView(),
                              _loginButton(context, state),
                              32.toSizedBoxHeight,
                              _biometricView(context),
                              _technicalSupportView(),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _fieldView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        12.toSizedBoxHeight,
        CustomTextFormField(
          controller: _authenticationCubit.usernameEditController,
          hintText: 'Username',
          inputType: TextInputType.number,
          validator: validatedUserName.call,
          maxLength: 40,
          suffixIconUrl: icUser,
          isShowSuffixIcon: true,
        ),
        16.toSizedBoxHeight,
        CustomTextFormField(
          controller: _authenticationCubit.passwordEditController,
          hintText: 'Password',
          validator: passwordValidator.call,
          isShowSuffixIcon: true,
          isPassword: true,
          inputAction: TextInputAction.done,
        ),
        24.toSizedBoxHeight,
      ],
    );
  }

  Widget _loginButton(BuildContext context, AuthenticationState state) {
    return CommonButtonWidget(
      buttonText: 'Login',
      isLoading: state is LoadingState,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _authenticationCubit.apiCallLogin(
            context: context,
            username: _authenticationCubit.usernameEditController.text
                .toString()
                .toString(),
            password: _authenticationCubit.passwordEditController.text
                .trim()
                .toString(),
          );
        }
      },
    );
  }

  Widget _biometricView(BuildContext context) {
    return Center(
      child: Visibility(
        visible: _authenticationCubit.isBiometricSupported &&
            _authenticationCubit.isAlreadyAuthenticatedForBiometric,
        child: InkWell(
            onTap: () {
              _authenticationCubit.authenticateBiometric(context);
            },
            child: icFingerPrintRound.imageAssetWidget(
                height: 60, width: 60, iconColor: colorBlue)),
      ),
    );
  }

  Widget _technicalSupportView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        24.toSizedBoxHeight,
        'Technical Support'.textWidget(
          color: colorBlue,
          fontSize: fontSizeMedium,
          fontWeight: FontWeight.bold,
        ),
        16.toSizedBoxHeight,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonIconButtonWidget(
              buttonText: '',
              buttonBgColor: colorBlue,
              buttonIconData: Icons.mail,
              onPressed: () async {
                const emailContent = 'support@gmail.com';
                Uri uri = Uri(scheme: 'mailto', path: emailContent);
                await launchUrl(uri);
              },
            ),
            10.toSizedBoxWidth,
            CommonIconButtonWidget(
              buttonText: '',
              buttonIconData: Icons.call,
              onPressed: () async {
                const phoneNumber = '+919999999999';
                const url = 'tel:$phoneNumber';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrlString(url);
                }
              },
            )
          ],
        ),
      ],
    );
  }
}
