import 'package:dartz/dartz.dart';
import 'package:fluttersampleapp/core/error/failure.dart';

abstract class UseCase<Result, Params> {
  Future<Either<Failure, Result>> call(Params params);
}
