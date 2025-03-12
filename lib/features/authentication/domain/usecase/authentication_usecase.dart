import 'dart:collection';

import 'package:dartz/dartz.dart';
import 'package:fluttersampleapp/core/domain/usecases/usecase.dart';
import 'package:fluttersampleapp/core/error/failure.dart';
import 'package:fluttersampleapp/features/authentication/data/models/login_response.dart';
import 'package:fluttersampleapp/features/authentication/domain/repo/authentication_repo.dart';

class AuthenticationUseCase
    extends UseCase<dynamic, HashMap<String, LoginResponse>> {
  final AuthenticationRepo repo;

  AuthenticationUseCase(this.repo);

  @override
  Future<Either<Failure, LoginResponse>> call(HashMap<String, dynamic> params) {
    return repo.login(params);
  }
}
