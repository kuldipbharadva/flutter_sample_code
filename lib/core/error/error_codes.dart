class ErrorCodes {
  static const int errorAtDatasource = 100;
  static const int errorAtRepository = 101;
}

class ErrorMessages {
  static const String errorMsgNoInternet =
      "No internet, check your device network connection!";
  static const String errorMsgSomethingWentWrong =
      "Something went wrong please try again";
  static const String errorMsgBadResponse = "Bad response";
  static const String errorMsgConnectionTimeout = "Connection timeout";
  static const String errorMsgServerTimeout = "Server timeout";
  static const String errorMsgSendTimeout = "Send timeout";
  static const String errorMsgRequestCancel = "Request cancelled";
  static const String errorMsgUnsupportedTypeSmartParser =
      "Unsupported type for smartParse";
}
