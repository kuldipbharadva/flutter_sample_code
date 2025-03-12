import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fluttersampleapp/core/data/datasources/i_remote_ds.dart';
import 'package:fluttersampleapp/core/dependency/global_get_it.dart';
import 'package:fluttersampleapp/core/error/error_codes.dart';
import 'package:fluttersampleapp/core/error/failure.dart';
import 'package:fluttersampleapp/core/model/i_response.dart';
import 'package:fluttersampleapp/core/model/response_model.dart';
import 'package:fluttersampleapp/core/utils/api_constants.dart';
import 'package:fluttersampleapp/core/utils/network_info.dart';
import 'package:http/http.dart' as http;

Map<String, String> commonHeader = {
  'Content-Type': 'application/json',
  'Accept': '*/*'
};

class RemoteDataSourceImpl extends IRemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({required this.client});

  @override
  Future<IResponse> executeGet({
    required String path,
    NetworkInfo? networkInfo,
    String? query,
    Map<String, String>? qParams,
    String? queryValue,
    String? token,
    Map<String, dynamic>? requestBody,
  }) async {
    bool isConnected = await globalGetIt<NetworkInfo>().isConnected;
    http.Response? response;

    if (isConnected) {
      try {
        if (kDebugMode) {
          print("ApiConstants.baseUrl : ${ApiConstants.baseUrl + path}");
        }
        ResponseModel responseData;
        qParams != null
            ? response = await client.get(
                Uri.http(ApiConstants.baseUrl, path, qParams),
              )
            : response = await client.get(
                Uri.http(ApiConstants.baseUrl, path,
                    query != null ? {query: queryValue} : null),
              );
        if (kDebugMode) {
          print('executeGet---> ${response.request!.url}');
          print('executeGet---> ${response.body}');
        }

        responseData = ResponseModel.fromJson(json.decode(response.body));
        if (kDebugMode) {
          print('::::::::::: ${response.body}');
        }
        if (response.statusCode == 200) {
          return responseData;
        } else {
          throw ServerFailure(
            statusFailCode: response.statusCode,
            statusMessage: response.reasonPhrase.toString(),
            errorFailMessage: response.reasonPhrase.toString(),
          );
        }
      } on FormatException {
        throw ServerFailure(
          statusFailCode: response?.statusCode,
          statusMessage: response?.reasonPhrase.toString(),
          errorFailMessage:
              "${response?.statusCode} ${response?.reasonPhrase.toString()}",
        );
      } on Exception catch (error) {
        if (kDebugMode) {
          print("exception error get : $error");
        }
        throw AppFailure(
          errorMessages: error.toString(),
          statusCodes: ErrorCodes.errorAtDatasource,
        );
      }
    } else {
      throw ErrorMessages.errorDeviceOffline;
    }
  }

  @override
  Future<IResponse> executePost({
    required String path,
    NetworkInfo? networkInfo,
    String? query,
    String? queryValue,
    String? token,
    Map<String, String>? qParams,
    Object? requestBody,
  }) async {
    bool isConnected = await globalGetIt<NetworkInfo>().isConnected;
    http.Response? response;

    if (isConnected) {
      try {
        ResponseModel responseData;
        if (kDebugMode) {
          print('api request url :: ${ApiConstants.baseUrl}$path');
          print('api request header :: ${commonHeader.toString()}');
          print('api request body :: ${requestBody.toString()}');
        }

        qParams != null
            ? response = await client.post(
                Uri.http(
                  ApiConstants.baseUrl,
                  path,
                  qParams,
                ),
                headers: commonHeader,
                body: requestBody,
              )
            : response = await client.post(
                Uri.http(ApiConstants.baseUrl, path,
                    query != null ? {query: queryValue} : null),
                headers: commonHeader,
                body: requestBody,
              );
        if (kDebugMode) {
          print('executePost :: ${response.request?.url ?? ''}');
          print('executePost :: ${response.body}');
        }

        responseData = ResponseModel.fromJson(json.decode(response.body));

        if (response.statusCode == 200) {
          return responseData;
        } else {
          throw ServerFailure(
            statusFailCode: response.statusCode,
            statusMessage: response.reasonPhrase.toString(),
            errorFailMessage: response.reasonPhrase.toString(),
          );
        }
      } on FormatException catch (error) {
        if (kDebugMode) {
          print("error in remote :: $error");
        }
        throw ServerFailure(
          statusFailCode: response?.statusCode,
          statusMessage: response?.reasonPhrase.toString(),
          errorFailMessage:
              "${response?.statusCode} ${response?.reasonPhrase.toString()}",
        );
      } on Exception catch (error) {
        if (kDebugMode) {
          print("error in remote  : $error");
        }
        throw AppFailure(
          errorMessages: error.toString(),
          statusCodes: ErrorCodes.errorAtDatasource,
        );
      }
    } else {
      throw ErrorMessages.errorDeviceOffline;
    }
  }
}
