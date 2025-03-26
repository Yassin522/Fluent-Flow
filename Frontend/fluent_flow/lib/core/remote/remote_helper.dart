import 'dart:convert';

import 'package:fluent_flow/core/cache/cache_helper.dart';
import 'package:fluent_flow/core/models/response_model.dart';
import 'package:http/http.dart' as http;

import '../const/api.dart';
import '../models/user_model.dart';


class RemoteHelper {
  final http.Client httpClient;
  final CacheHelper cacheHelper;

  RemoteHelper({required this.httpClient, required this.cacheHelper});

  Future<bool> logout() async {

    final String? token = cacheHelper.getToken();
    if (token == null) {
      throw Exception('You are not logged in');
    }
    final url = Uri.parse('$IP_PORT/api/auth/logout');
    final response = await httpClient.post(url, 
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },).timeout(const Duration(seconds: 15));
    var responseBody = ResponseModel.fromJson(json.decode(response.body));
    if(response.statusCode == 200) {
      return true;
    }
    else {
      throw Exception(responseBody.message);
    }
  }

  Future<bool> logoutAll() async {

    final String? token = cacheHelper.getToken();
    if (token == null) {
      throw Exception('You are not logged in (all)');
    }
    final url = Uri.parse('$IP_PORT/api/auth/logoutFromAll');
    final response = await httpClient.post(url, 
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },).timeout(const Duration(seconds: 15));
    var responseBody = ResponseModel.fromJson(json.decode(response.body));
    if(response.statusCode == 200) {
      return true;
    }
    else {
      throw Exception(responseBody.message);
    }
  }

  Future<UserModel> getRemoteUser() async {
    String? token;
    token = cacheHelper.getToken();

    final url = Uri.parse('$IP_PORT/api/me'); 

    final response = await httpClient.get(url
    , headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }).timeout(const Duration(seconds: 15));
    
    var responseBody = ResponseModel.fromJson(json.decode(response.body));

    if (response.statusCode == 200) {
      return UserModel.fromJson(responseBody.data!);
    }else if (response.statusCode == 401) {
      throw Exception('401');
    } else {
      throw Exception('error in your profile');
    }
  }
}
