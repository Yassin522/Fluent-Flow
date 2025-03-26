
import 'package:fluent_flow/core/entities/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {

  const UserModel({
    required int id, 
    required String email, 
    required String name, 
    required String role, 
    required String? imageUrl,
  }) : super(
    name: name,
    email: email,
    id: id,
    imageUrl: imageUrl,
    role: role,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}