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
import 'package:fluttersampleapp/features/authentication/presentation/blocs/auth_bloc.dart';
import 'package:fluttersampleapp/features/authentication/presentation/blocs/auth_event.dart';
import 'package:fluttersampleapp/features/authentication/presentation/blocs/auth_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

@RoutePage()
class LoginScreenBlocUsage extends StatefulWidget {
  const LoginScreenBlocUsage({super.key});

  @override
  LoginScreenBlocUsageState createState() => LoginScreenBlocUsageState();
}

class LoginScreenBlocUsageState extends State<LoginScreenBlocUsage> {
  late AuthBloc _authBloc;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _authBloc = authGetIt.get<AuthBloc>();
    _authBloc.getClientDeviceInformation();
    _authBloc.usernameEditController.text = 'test';
    _authBloc.passwordEditController.text = 'test@123';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return _authBloc;
      },
      child: BlocConsumer<AuthBloc, AuthState>(
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
          controller: _authBloc.usernameEditController,
          hintText: 'Username',
          inputType: TextInputType.number,
          validator: validatedUserName.call,
          maxLength: 40,
          suffixIconUrl: icUser,
          isShowSuffixIcon: true,
        ),
        16.toSizedBoxHeight,
        CustomTextFormField(
          controller: _authBloc.passwordEditController,
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

  Widget _loginButton(BuildContext context, AuthState state) {
    return CommonButtonWidget(
      buttonText: 'Login',
      isLoading: state is LoadingState,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _authBloc.add(LoginRequestEvent(
            context,
            _authBloc.usernameEditController.text.trim(),
            _authBloc.passwordEditController.text.trim(),
          ));
        }
      },
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
