import 'dart:convert';
import 'package:fluent_flow/features/login/data/models/login_model.dart';
import 'package:fluent_flow/features/login/domain/entities/login_response.dart';
import 'package:http/http.dart' as http;
import '../../../../core/const/api.dart';

class LogInRemoteDataSource {

  final http.Client httpClient;

  LogInRemoteDataSource({required this.httpClient});

  Future<LogInResponse> login({
    required String email,
    required String password,
  }) async { 

    final url = Uri.parse('$IP_PORT/api/login');
    final body = {
      "email": email,
      "password": password
    };
    
    final response = await httpClient.post(url, body: body, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      return LogInModel.fromJson(json.decode(response.body));
    }else {
      throw Exception("Wrong Email Or Password");
    }
  }
}
