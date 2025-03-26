import 'package:equatable/equatable.dart';
import 'package:fluent_flow/core/models/user_model.dart';

class LogInResponse extends Equatable{
  final UserModel user;
  final String token;

  const LogInResponse({required this.token, required this.user});
  
  @override
  List<Object?> get props => [user, token];
}
