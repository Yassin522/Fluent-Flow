import 'package:fluent_flow/core/models/user_model.dart';
import 'package:fluent_flow/features/login/domain/entities/login_response.dart';

class LogInModel extends LogInResponse {

  const LogInModel({required String token, required UserModel user}) : super(token: token, user: user);

  factory LogInModel.fromJson(Map<String, dynamic> json){
    return LogInModel(token: json['token'], user: UserModel.fromJson(json['customer']));
  }

  Map<String, dynamic> toJson(){
    return {
      'token': token, 
      'user': user,
    };
  }
}
