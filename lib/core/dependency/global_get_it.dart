import 'package:dio/dio.dart';
import 'package:fluttersampleapp/core/data/datasources/i_remote_ds.dart';
import 'package:fluttersampleapp/core/data/datasources/i_remote_ds_dio.dart';
import 'package:fluttersampleapp/core/data/datasources/remote_ds_impl.dart';
import 'package:fluttersampleapp/core/data/datasources/remote_ds_impl_dio.dart';
import 'package:fluttersampleapp/core/interceptors/refresh_token_interceptor.dart';
import 'package:fluttersampleapp/core/storage/i_preference.dart';
import 'package:fluttersampleapp/core/storage/preference_impl.dart';
import 'package:fluttersampleapp/core/utils/api_constants.dart';
import 'package:fluttersampleapp/core/utils/network_info.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

final GetIt globalGetIt = GetIt.instance;

Future<void> setupGlobalGetIt() async {
  globalGetIt.registerLazySingleton(
    () => InternetConnectionChecker.instance,
  );

  globalGetIt.registerLazySingleton<IPreference>(
    () => PreferenceImpl(),
  );

  globalGetIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      globalGetIt(),
    ),
  );

  globalGetIt.registerLazySingleton(
    () => http.Client(),
  );

  globalGetIt.registerLazySingleton<Dio>(
    () {
      final dio = Dio();
      dio.options = BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      );
      dio.interceptors.add(RefreshTokenInterceptor(dio: dio));
      return dio;
    },
  );

  globalGetIt.registerLazySingleton<IRemoteDataSource>(
    () => RemoteDataSourceImpl(
      client: globalGetIt(),
    ),
  );
  globalGetIt.registerLazySingleton<IRemoteDataSourceDio>(
    () => RemoteDataSourceImplDio(
      client: globalGetIt(),
    ),
  );
}
