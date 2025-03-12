import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttersampleapp/core/data/datasources/i_remote_ds_dio.dart';
import 'package:fluttersampleapp/core/error/error_codes.dart';
import 'package:fluttersampleapp/core/error/failure.dart';
import 'package:fluttersampleapp/core/utils/api_constants.dart';
import 'package:fluttersampleapp/core/utils/app_strings.dart';
import 'package:fluttersampleapp/features/authentication/data/models/login_response.dart';
import 'dart:collection';

import 'package:fluttersampleapp/features/authentication/domain/repo/authentication_repo.dart';

class AuthenticationRepoImpl implements AuthenticationRepo {
  final IRemoteDataSourceDio remoteDataSource;

  AuthenticationRepoImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, LoginResponse>> login(
      HashMap<String, dynamic> hashMap) async {
    try {
      final res = await remoteDataSource.executePost(
          path: ApiConstants.login, requestBody: jsonEncode(hashMap));
      return Right(LoginResponse.fromJson(res));
    } on DioException catch (e) {
      if (kDebugMode) {
        print('logcat :: api response catch = ${e.response?.data}');
      }
      return Left(
        AppFailure(
          errorMessages: (e.response?.data['error']['message'] ??
              (e.response?.statusMessage ?? unknownErrorMsg)),
          statusCodes: ErrorCodes.errorAtRepository,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('logcat :: api response catch = ${e.toString()}');
      }
      return Left(
        AppFailure(
          errorMessages: e.toString(),
          statusCodes: ErrorCodes.errorAtRepository,
        ),
      );
    }
  }
}
