import 'package:auto_route/auto_route.dart';
import 'package:fluttersampleapp/core/routes/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> routes = [
    AutoRoute(path: RouteConstant.splashScreen, page: SplashRoute.page),
    AutoRoute(path: RouteConstant.loginScreen, page: LoginRoute.page),
    AutoRoute(
      path: RouteConstant.loginScreenBlocUsage,
      page: LoginRouteBlocUsage.page,
    ),
  ];
}

class RouteConstant {
  static const String splashScreen = '/';
  static const String loginScreen = '/login';
  static const String loginScreenBlocUsage = '/loginBloc';
}
