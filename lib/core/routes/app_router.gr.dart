// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:fluttersampleapp/features/authentication/presentation/pages/login_screen.dart'
    as _i1;
import 'package:fluttersampleapp/features/authentication/presentation/pages/login_screen_bloc_usage.dart'
    as _i2;
import 'package:fluttersampleapp/features/authentication/presentation/pages/splash_screen.dart'
    as _i3;

/// generated route for
/// [_i1.LoginScreen]
class LoginRoute extends _i4.PageRouteInfo<void> {
  const LoginRoute({List<_i4.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i1.LoginScreen();
    },
  );
}

/// generated route for
/// [_i2.LoginScreenBlocUsage]
class LoginRouteBlocUsage extends _i4.PageRouteInfo<void> {
  const LoginRouteBlocUsage({List<_i4.PageRouteInfo>? children})
    : super(LoginRouteBlocUsage.name, initialChildren: children);

  static const String name = 'LoginRouteBlocUsage';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i2.LoginScreenBlocUsage();
    },
  );
}

/// generated route for
/// [_i3.SplashScreen]
class SplashRoute extends _i4.PageRouteInfo<void> {
  const SplashRoute({List<_i4.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i3.SplashScreen();
    },
  );
}
