import 'package:dartz/dartz.dart';
import 'package:fluttersampleapp/core/data/datasources/remote_ds_impl_dio_common.dart';
import 'package:fluttersampleapp/core/error/failure.dart';

abstract class IRemoteDataSourceDioCommon {
  Future<Either<Failure, T>> executeGet<T>({
    required String url,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic> requestBody,
    T Function(dynamic)? fromJson,
  });

  Future<Either<Failure, T>> executePost<T>({
    required String url,
    Map<String, String>? queryParams,
    Object? requestBody,
    T Function(dynamic)? fromJson,
  });

  Future<Either<Failure, T>> requestCall<T>({
    required ApiRequestOptions requestOption,
    T Function(dynamic)? fromJson,
  });
}

// T Function(dynamic)? fromJson
// This function will parse our json to particular model and if we got response in
// string, int or bool then we don't need to parse it bCoz smartParser function will parse automatically
