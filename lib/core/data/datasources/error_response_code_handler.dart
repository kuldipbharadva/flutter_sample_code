import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ErrorResponseCodeHandler {
  static Future<void> errorCodeHandler(
      {required int statusCode, required String errorMsg, required Function callback}) async {
    switch (statusCode) {
      case 401:
        callback();
        return;
      default:
        Fluttertoast.showToast(msg: errorMsg);
        return;
    }
  }

  // String errorCodeMsg({required int statusCode}) {
  //   switch (statusCode) {
  //     case 401:
  //       return 'Unauthorized'
  //   }
  // }

  Exception handleDioError(DioException exception) {
    if (exception.type == DioExceptionType.connectionTimeout) {
      return Exception("Connection timeout. Please try again.");
    } else if (exception.type == DioExceptionType.receiveTimeout) {
      return Exception("Server response timeout. Please try again.");
    } else if (exception.response != null) {
      final statusCode = exception.response?.statusCode;
      final message =
          exception.response?.statusMessage ?? "Unknown error occurred.";
      return Exception("Error $statusCode: $message");
    } else {
      return Exception("Something went wrong. Please try again.");
    }
  }
}
