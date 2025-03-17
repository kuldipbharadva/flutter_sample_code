import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AuthEvent extends Equatable {}

class InitEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class LoginRequestEvent extends AuthEvent {
  final BuildContext context;
  final String? username;
  final String? password;

  LoginRequestEvent(this.context, this.username, this.password);

  @override
  List<Object?> get props => [username, password];
}
