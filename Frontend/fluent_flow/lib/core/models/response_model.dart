import 'package:fluent_flow/core/entities/response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_model.g.dart';

@JsonSerializable()
class ResponseModel extends Response {

  const ResponseModel({required Map<String, dynamic>? data, required String? message}) : super(data: data, message: message);

  factory ResponseModel.fromJson(Map<String, dynamic> json) => _$ResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
}