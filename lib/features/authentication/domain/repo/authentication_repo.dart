import 'dart:collection';

import 'package:dartz/dartz.dart';
import 'package:fluttersampleapp/core/error/failure.dart';
import 'package:fluttersampleapp/features/authentication/data/models/login_response.dart';

abstract class AuthenticationRepo {
  Future<Either<Failure, LoginResponse>> login(
      HashMap<String, dynamic> hashMap);
}
