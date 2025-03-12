import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttersampleapp/core/utils/api_constants.dart';
import 'package:fluttersampleapp/main.dart';

class RefreshTokenInterceptor extends Interceptor {
  final Dio? dio;

  RefreshTokenInterceptor({required this.dio});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      print(
          'logcat :: interceptor onError called = ${err.response?.statusCode}');
    }
    // return handler
    //     .resolve(err.response ?? Response(requestOptions: err.requestOptions));
    // return handler.next(err);
    try {
      if (err.response?.statusCode == 401 &&
          err.response?.requestOptions.path != ApiConstants.refreshToken) {
        await isRefreshedToken().then((value) async {
          if (value) {
            return handler.resolve(await _retryApiCall(err.requestOptions));
          } else {
            return handler.next(err);
          }
        });
      } else {
        return handler.next(err);
      }
    } on DioException catch (err) {
      if (kDebugMode) {
        print(
            'logcat :: interceptor onError DioException = ${err.response?.statusCode}');
      }
      return handler.next(err);
    } catch (e) {
      if (kDebugMode) {
        print('logcat :: interceptor onError catch = ${e.toString()}');
      }
      return handler.next(err);
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('logcat :: interceptor onRequest path = ${options.path}');
    }
    if (!options.path.contains(ApiConstants.login)) {
      options.headers = {
        'Accept-Language': 'ar-JO',
        'Authorization': 'Bearer ${preferenceInfoModel.token}',
      };
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (kDebugMode) {
      print(
          'logcat :: interceptor onResponse status code => ${response.statusCode}');
      print(
          'logcat :: interceptor onResponse request options => ${response.requestOptions.toString()}');
    }
    if (response.statusCode == 401 &&
        response.requestOptions.path != ApiConstants.refreshToken) {
      await isRefreshedToken().then((value) async {
        if (value) {
          return handler.resolve(await _retryApiCall(response.requestOptions));
        } else {
          return handler.next(response);
        }
      });
    } else {
      return handler.next(response);
    }
  }

  Future<bool> isRefreshedToken() async {
    bool isSuccess = false;

    final reqData = {
      'tokenRefresh': preferenceInfoModel.tokenRefresh,
      'username': preferenceInfoModel.username,
    };
    if (kDebugMode) {
      print('logcat :: refresh api request body :: ${reqData.toString()}');
    }

    Response? res = await dio?.post(ApiConstants.refreshToken, data: reqData);

    if (res?.statusCode == 200 || res?.statusCode == 201) {
      if (kDebugMode) {
        print('logcat :: interceptor refresh token success');
      }
      /* TODO static manage this api response with your response model, below is the reference for you */
      /*LoginResponse loginRes = LoginResponse.fromJson(res?.data);
      preferenceInfoModel.token = loginRes.token;
      preferenceInfoModel.tokenRefresh = loginRes.tokenRefresh;
      if (kDebugMode) {
        print(
            'logcat :: interceptor refresh token res = ${loginRes.tokenRefresh}');
      }*/
      isSuccess = true;
    } else {
      if (kDebugMode) {
        print(
            'logcat :: interceptor refresh token api error = ${res?.statusCode}');
      }
      isSuccess = false;
    }
    return isSuccess;
  }

  Future<Response<dynamic>> _retryApiCall(RequestOptions requestOptions) async {
    if (kDebugMode) {
      print('logcat :: interceptor retry called');
    }
    final options = Options(method: requestOptions.method, headers: {
      'Accept-Language': 'ar-JO',
      'Authorization': 'Bearer ${preferenceInfoModel.token}',
    });

    if (kDebugMode) {
      print('retry = api request url :: ${requestOptions.path}');
      print('retry = api request body :: ${requestOptions.data.toString()}');
      print(
          'retry = api request query params :: ${requestOptions.queryParameters.toString()}');
    }

    return (dio ?? Dio()).request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }
}
