import 'package:dio/dio.dart';
import 'package:fluttersampleapp/core/utils/api_constants.dart';
import 'package:fluttersampleapp/core/utils/common_functions.dart';
import 'package:fluttersampleapp/main.dart';

class RefreshTokenInterceptor extends Interceptor {
  final Dio? dio;

  RefreshTokenInterceptor({required this.dio});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    logcat('interceptor onError called = ${err.response?.statusCode}');
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
      logcat('interceptor onError DioException = ${err.response?.statusCode}');
      return handler.next(err);
    } catch (e) {
      logcat('interceptor onError catch = ${e.toString()}');
      logcat('interceptor onError catch = ${e.toString()}');
      return handler.next(err);
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logcat('interceptor onRequest path = ${options.path}');
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
    logcat('interceptor onResponse status code => ${response.statusCode}');
    logcat(
      'interceptor onResponse request options => ${response.requestOptions.toString()}',
    );
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
    logcat('refresh api request body :: ${reqData.toString()}');

    Response? res = await dio?.post(ApiConstants.refreshToken, data: reqData);

    if (res?.statusCode == 200 || res?.statusCode == 201) {
      logcat('interceptor refresh token success');
      /* TODO static manage this api response with your response model, below is the reference for you */
      /*LoginResponse loginRes = LoginResponse.fromJson(res?.data);
      preferenceInfoModel.token = loginRes.token;
      preferenceInfoModel.tokenRefresh = loginRes.tokenRefresh;

      logcat('interceptor refresh token res = ${loginRes.tokenRefresh}');*/
      isSuccess = true;
    } else {
      logcat('interceptor refresh token api error = ${res?.statusCode}');
      isSuccess = false;
    }
    return isSuccess;
  }

  Future<Response<dynamic>> _retryApiCall(RequestOptions requestOptions) async {
    logcat('interceptor retry called');
    final options = Options(
      method: requestOptions.method,
      headers: {
        'Accept-Language': 'ar-JO',
        'Authorization': 'Bearer ${preferenceInfoModel.token}',
      },
    );

    logcat('retry = api request url :: ${requestOptions.path}');
    logcat('retry = api request body :: ${requestOptions.data.toString()}');
    logcat(
      'retry = api request query params :: ${requestOptions.queryParameters.toString()}',
    );

    return (dio ?? Dio()).request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
