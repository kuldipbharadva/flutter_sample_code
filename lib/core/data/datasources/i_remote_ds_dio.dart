import 'package:fluttersampleapp/core/utils/network_info.dart';

abstract class IRemoteDataSourceDio {
  Future<T> executeGet<T>({
    required String path,
    NetworkInfo? networkInfo,
    String token,
    // String? query,
    // String? queryValue,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic> requestBody,
  });

  Future<T> executePost<T>({
    required String path,
    NetworkInfo? networkInfo,
    String token,
    // String? query,
    // String? queryValue,
    Map<String, String>? queryParams,
    Object? requestBody,
  });
}
