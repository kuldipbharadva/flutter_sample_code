import 'package:fluttersampleapp/core/model/i_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_model.g.dart';

@JsonSerializable()
class ResponseModel implements IResponse {
  final bool? isError;
  // final bool? isValidationFailed;
  final int? code;
  final String? message;
  final dynamic data;

  ResponseModel({
    this.data,
    this.isError,
    // this.isValidationFailed,
    this.code,
    this.message,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
}
