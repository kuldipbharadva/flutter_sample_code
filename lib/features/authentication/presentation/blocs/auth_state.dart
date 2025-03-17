import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  AuthState init() {
    return AuthState();
  }

  @override
  List<Object?> get props => [];
}

class LoadingState extends AuthState {
  LoadingState();

  @override
  List<Object?> get props => [];
}

class SuccessState extends AuthState {
  SuccessState();

  @override
  List<Object?> get props => [];
}

class FailureState extends AuthState {
  final String? msg;

  FailureState({this.msg});

  @override
  List<Object?> get props => [msg];
}
