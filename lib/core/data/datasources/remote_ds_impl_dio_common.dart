import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fluttersampleapp/core/data/datasources/i_remote_ds_dio_common.dart';
import 'package:fluttersampleapp/core/dependency/global_get_it.dart';
import 'package:fluttersampleapp/core/error/error_codes.dart';
import 'package:fluttersampleapp/core/error/failure.dart';
import 'package:fluttersampleapp/core/utils/api_constants.dart';
import 'package:fluttersampleapp/core/utils/app_strings.dart';
import 'package:fluttersampleapp/core/utils/common_functions.dart';
import 'package:fluttersampleapp/core/utils/network_info.dart';
import 'package:fluttersampleapp/main.dart';

class RemoteDataSourceImplDioCommon extends IRemoteDataSourceDioCommon {
  final Dio client;

  RemoteDataSourceImplDioCommon({required this.client});

  @override
  Future<Either<Failure, T>> executeGet<T>({
    required String url,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? requestBody,
    T Function(dynamic)? fromJson,
  }) async {
    bool isConnected = await globalGetIt<NetworkInfo>().isConnected;
    if (isConnected) {
      client.options.headers = {}; // manage you common header
      if (!url.contains(ApiConstants.login)) {
        client.options.headers.addAll({
          'Authorization': 'Bearer ${preferenceInfoModel.token}',
        });
      }
      logcat('api request url :: ${ApiConstants.baseUrl}$url');
      logcat('api request header :: ${client.options.headers}');
      logcat('api request body :: ${requestBody.toString()}');
      logcat('api request query params :: ${queryParams.toString()}');

      try {
        final response = await client.get(
          url,
          queryParameters: queryParams,
          data: requestBody,
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          final parsedJsonData = fromJson != null
              ? fromJson(response.data)
              : smartParse<T>(response.data);
          logcat('api response parsed => ${response.toString()}');
          return Right(parsedJsonData);
        } else {
          return Left(
            Failure(
              errorMessage: response.statusMessage ?? unknownErrorMsg,
              statusCode: response.statusCode ?? 100,
            ),
          );
        }
      } on DioException catch (e) {
        return Left(handleDioException(e));
      } catch (e) {
        return Left(Failure(errorMessage: e.toString(), statusCode: 1002));
      }
    } else {
      return Left(
        Failure(
          errorMessage: ErrorMessages.errorMsgNoInternet,
          statusCode: 1003,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, T>> executePost<T>({
    required String url,
    String? token,
    Map<String, String>? queryParams,
    Object? requestBody,
    T Function(dynamic)? fromJson,
  }) async {
    bool isConnected = await globalGetIt<NetworkInfo>().isConnected;
    if (isConnected) {
      client.options.headers = {'': ''};
      if (!url.contains(ApiConstants.login)) {
        client.options.headers.addAll({
          'Authorization': 'Bearer ${preferenceInfoModel.token}',
        });
      }

      logcat('api request url :: ${ApiConstants.baseUrl}$url');
      logcat('api request header :: ${client.options.headers}');
      logcat('api request body :: ${requestBody.toString()}');
      logcat('api request query params :: ${queryParams.toString()}');

      try {
        final response = await client.post(
          url,
          queryParameters: queryParams,
          data: requestBody,
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          final parsedJsonData = fromJson != null
              ? fromJson(response.data)
              : smartParse<T>(response.data);
          logcat('api response parsed => ${response.toString()}');
          return Right(parsedJsonData);
        } else {
          return Left(
            Failure(
              errorMessage: response.statusMessage ?? unknownErrorMsg,
              statusCode: response.statusCode ?? 100,
            ),
          );
        }
      } on DioException catch (e) {
        return Left(handleDioException(e));
      } catch (e) {
        return Left(Failure(errorMessage: e.toString(), statusCode: 1002));
      }
    } else {
      return Left(
        Failure(
          errorMessage: ErrorMessages.errorMsgNoInternet,
          statusCode: 1003,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, T>> requestCall<T>({
    required ApiRequestOptions requestOption,
    T Function(dynamic res)? fromJson,
  }) async {
    bool isConnected = await globalGetIt<NetworkInfo>().isConnected;
    if (isConnected) {
      client.options.headers = {'': ''};
      if (!requestOption.url.contains(ApiConstants.login)) {
        client.options.headers.addAll({
          'Authorization': 'Bearer ${preferenceInfoModel.token}',
        });
      }

      try {
        final response = await _makeRequest(requestOption);
        final statusCode = response.statusCode ?? 0;

        if (statusCode == 200 || statusCode == 201) {
          final parsedJsonData = fromJson != null
              ? fromJson(response.data)
              : smartParse<T>(response.data);
          logcat('api response parsed => ${response.toString()}');
          return Right(parsedJsonData);
        } else {
          return Left(
            Failure(
              errorMessage: response.statusMessage ?? unknownErrorMsg,
              statusCode: response.statusCode ?? 100,
            ),
          );
        }
      } on DioException catch (e) {
        return Left(handleDioException(e));
      } catch (e) {
        return Left(Failure(errorMessage: e.toString(), statusCode: 1002));
      }
    } else {
      return Left(
        Failure(
          errorMessage: ErrorMessages.errorMsgNoInternet,
          statusCode: 1003,
        ),
      );
    }
  }

  Future<Response> _makeRequest(ApiRequestOptions opts) async {
    // final Options dioOptions = Options(headers: opts.headers);
    dynamic data;
    if (opts.methodType == RequestMethodType.get) {
      data = null;
    } else if (opts.contentType == RequestContentType.formData) {
      data = FormData.fromMap(opts.requestBody ?? {});
    } else {
      data = opts.requestBody;
    }

    logcat('api request call url :: ${ApiConstants.baseUrl}${opts.url}');
    logcat('api request call method type :: ${opts.methodType}');
    logcat('api request call header :: ${client.options.headers}');
    logcat('api request call query params :: ${opts.queryParams.toString()}');
    logcat('api request call body :: ${data.toString()}');

    switch (opts.methodType) {
      case RequestMethodType.get:
        return await client.get(
          opts.url,
          queryParameters: opts.queryParams,
          // options: dioOptions,
        );
      case RequestMethodType.post:
        return await client.post(
          opts.url,
          data: data,
          queryParameters: opts.queryParams,
          // options: dioOptions,
        );
      case RequestMethodType.put:
        return await client.put(
          opts.url,
          data: data,
          queryParameters: opts.queryParams,
          // options: dioOptions,
        );
      case RequestMethodType.delete:
        return await client.delete(
          opts.url,
          data: data,
          queryParameters: opts.queryParams,
          // options: dioOptions,
        );
    }
  }

  Failure handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Failure(
          errorMessage: ErrorMessages.errorMsgConnectionTimeout,
          statusCode: e.response?.statusCode ?? 1001,
        );
      case DioExceptionType.receiveTimeout:
        return Failure(
          errorMessage: ErrorMessages.errorMsgServerTimeout,
          statusCode: e.response?.statusCode ?? 1001,
        );
      case DioExceptionType.badResponse:
        return Failure(
          errorMessage:
              e.response?.statusMessage ??
              "${ErrorMessages.errorMsgBadResponse}, ${ErrorMessages.errorMsgSomethingWentWrong}",
          statusCode: e.response?.statusCode ?? 1001,
        );
      case DioExceptionType.cancel:
        return Failure(
          errorMessage: ErrorMessages.errorMsgRequestCancel,
          statusCode: e.response?.statusCode ?? 1001,
        );
      case DioExceptionType.sendTimeout:
        return Failure(
          errorMessage: ErrorMessages.errorMsgSendTimeout,
          statusCode: e.response?.statusCode ?? 1001,
        );
      default:
        return Failure(
          errorMessage: "Unexpected error: ${e.message}",
          statusCode: e.response?.statusCode ?? 1001,
        );
    }
  }
}

T smartParse<T>(dynamic json) {
  if (T == String) return json.toString() as T;
  if (T == int) return int.tryParse(json.toString()) as T? ?? 0 as T;
  if (T == bool) return (json == true || json.toString() == 'true') as T;

  throw Exception("${ErrorMessages.errorMsgUnsupportedTypeSmartParser}: $T");
}

enum RequestContentType { json, formData }

enum RequestMethodType { get, post, put, delete }

class ApiRequestOptions {
  final String url;
  final RequestMethodType methodType;
  final Map<String, String>? headers;
  final Map<String, dynamic>? queryParams;
  final dynamic requestBody; // Can be JSON or FormData
  final RequestContentType contentType;

  ApiRequestOptions({
    required this.url,
    required this.methodType,
    this.headers,
    this.queryParams,
    this.requestBody,
    this.contentType = RequestContentType.json,
  });
}
