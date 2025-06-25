import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttersampleapp/core/data/datasources/i_remote_ds_dio.dart';
import 'package:fluttersampleapp/core/dependency/global_get_it.dart';
import 'package:fluttersampleapp/core/error/error_codes.dart';
import 'package:fluttersampleapp/core/error/failure.dart';
import 'package:fluttersampleapp/core/utils/api_constants.dart';
import 'package:fluttersampleapp/core/utils/network_info.dart';
import 'package:fluttersampleapp/main.dart';

class RemoteDataSourceImplDio extends IRemoteDataSourceDio {
  // final http.Client client;
  final Dio client;

  RemoteDataSourceImplDio({required this.client});

  @override
  Future<T> executeGet<T>({
    required String path,
    NetworkInfo? networkInfo,
    String? token,
    // String? query,
    // String? queryValue,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? requestBody,
  }) async {
    bool isConnected = await globalGetIt<NetworkInfo>().isConnected;
    Response? response;

    if (isConnected) {
      client.options.headers = {};
      if (!path.contains(ApiConstants.login)) {
        client.options.headers.addAll({
          'Authorization': 'Bearer ${preferenceInfoModel.token}',
        });
      }
      if (kDebugMode) {
        print('api request url :: ${ApiConstants.baseUrl}$path');
        print('api request header :: ${client.options.headers}');
        print('api request body :: ${requestBody.toString()}');
        print('api request query params :: ${queryParams.toString()}');
      }

      response = await client.get(
        path,
        queryParameters: queryParams,
        data: requestBody,
      );
      if (kDebugMode) {
        print('executeGet :: response => ${response.data}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw ServerFailure(
          statusFailCode: response.statusCode,
          statusMessage: response.statusMessage,
          errorFailMessage: '',
        );
      }
    } else {
      throw ErrorMessages.errorMsgNoInternet;
    }
  }

  @override
  Future<T> executePost<T>({
    required String path,
    NetworkInfo? networkInfo,
    // String? query,
    // String? queryValue,
    String? token,
    Map<String, String>? queryParams,
    Object? requestBody,
  }) async {
    bool isConnected = await globalGetIt<NetworkInfo>().isConnected;
    Response? response;

    if (isConnected) {
      client.options.headers = {'Accept-Language': 'ar-JO'};
      if (!path.contains(ApiConstants.login)) {
        client.options.headers.addAll({
          'Authorization': 'Bearer ${preferenceInfoModel.token}',
        });
      }

      if (kDebugMode) {
        print('api request url :: ${ApiConstants.baseUrl}$path');
        print('api request header :: ${client.options.headers}');
        print('api request body :: ${requestBody.toString()}');
        print('api request query params :: ${queryParams.toString()}');
      }

      response = await client.post(
        path,
        queryParameters: queryParams,
        data: requestBody,
      );
      if (kDebugMode) {
        print('executePost :: response => ${response.data}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        if (kDebugMode) {
          print('executePost :: response failed => ${response.data}');
        }
        throw ServerFailure(
          statusFailCode: response.statusCode,
          statusMessage: response.statusMessage,
          errorFailMessage: '',
        );
      }
    } else {
      throw ErrorMessages.errorMsgNoInternet;
    }
  }
}
