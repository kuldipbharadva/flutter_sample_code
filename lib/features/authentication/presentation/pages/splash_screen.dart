import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttersampleapp/core/utils/app_extensions.dart';
import 'package:fluttersampleapp/core/utils/image_constants.dart';
import 'package:fluttersampleapp/features/authentication/dependency/auth_get_it.dart';
import 'package:fluttersampleapp/features/authentication/presentation/cubits/authentication_cubit.dart';
import 'package:fluttersampleapp/features/authentication/presentation/cubits/authentication_state.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthenticationCubit _authenticationCubit;

  @override
  void initState() {
    _authenticationCubit = authGetIt.get<AuthenticationCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          _authenticationCubit.navigateScreen(context: context);
          return _authenticationCubit;
        },
        child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, state) {
            return SafeArea(
              child: Center(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: icLogoWhite.imageAssetWidget(
                        height: 130.h, width: 130.h)),
              ),
            );
          },
        ),
      ),
    );
  }
}
