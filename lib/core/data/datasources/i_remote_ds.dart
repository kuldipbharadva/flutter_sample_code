import 'package:fluttersampleapp/core/model/i_response.dart';
import 'package:fluttersampleapp/core/utils/network_info.dart';

abstract class IRemoteDataSource {
  Future<IResponse> executeGet({
    required String path,
    NetworkInfo? networkInfo,
    String? query,
    String? queryValue,
    Map<String, String>? qParams,
    String token,
    Map<String, dynamic> requestBody,
  });

  Future<IResponse> executePost({
    required String path,
    NetworkInfo? networkInfo,
    String? query,
    String? queryValue,
    String token,
    Map<String, String>? qParams,
    Object? requestBody,
  });
}
