class AuthenticationState {
  AuthenticationState init() {
    return AuthenticationState();
  }
}

class LoadingState extends AuthenticationState {
  LoadingState();
}

class SuccessState extends AuthenticationState {
  SuccessState();
}

class FailureState extends AuthenticationState {
  String? msg;

  FailureState({this.msg});
}
