import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/const/api.dart';

class RegisterRemoteDataSource {
  final http.Client httpClient;
  RegisterRemoteDataSource({required this.httpClient});

  Future<void> register({
    required String email,
    required String password,
    required String job,
    required String name
  }) async {
    final url = Uri.parse('$IP_PORT/api/register');
    final body = jsonEncode({
      "user": {
        "username": name.replaceAll(" ", "_"),
        "email": email,
        "password": password
      },
      "name": name,
      "role": job
    });

    try {
      final response = await httpClient.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else if (response.statusCode == 400) {
        throw Exception('A user with that username already exists');
      } else {
        throw Exception('Error in register');
      }
    } catch (e) {
      throw Exception('Error in register');
    }
  }
}