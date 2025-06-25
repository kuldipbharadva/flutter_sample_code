import 'package:equatable/equatable.dart';

// abstract class Failure extends Equatable {
class Failure extends Equatable {
  final String errorMessage;
  final int statusCode;

  const Failure({required this.errorMessage, required this.statusCode});

  @override
  List<Object?> get props => [errorMessage, statusCode];
}

class ServerFailure extends Failure {
  final String? statusMessage;
  final int? statusFailCode;
  final String? errorFailMessage;

  const ServerFailure({
    required this.statusMessage,
    required this.statusFailCode,
    required this.errorFailMessage,
  }) : super(
         errorMessage: errorFailMessage ?? "",
         statusCode: statusFailCode ?? 200,
       );

  @override
  List<Object?> get props => [statusMessage, statusCode, errorMessage];

  @override
  String toString() {
    return '$statusCode $statusMessage $errorMessage';
  }
}

class AppFailure extends Failure {
  final int statusCodes;
  final String errorMessages;

  const AppFailure({required this.statusCodes, required this.errorMessages})
    : super(errorMessage: errorMessages, statusCode: statusCodes);

  @override
  List<Object?> get props => [statusCode, errorMessage];

  @override
  String toString() {
    return '$statusCode $errorMessage';
  }
}
