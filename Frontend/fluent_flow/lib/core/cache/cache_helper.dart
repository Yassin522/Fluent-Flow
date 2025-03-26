
import 'dart:convert';
import 'package:fluent_flow/core/const/failure_messages.dart';
import 'package:fluent_flow/core/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  final SharedPreferences sharedPreferences;

  CacheHelper({required this.sharedPreferences});

  dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  String? getToken() {
    final token = sharedPreferences.get('token') as String?;
    if (token != null) {
      return token;
    } else {
      return null;
    }
  }

  Future<bool> saveData({required String key, required dynamic value}) async {

    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is double) return await sharedPreferences.setDouble(key, value);
    return true;
  }

  Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  Future<bool> saveUser({required UserModel user}) async {
    return await sharedPreferences.setString('user', json.encode(user.toJson()));
  }

  Future<UserModel> getSavedUser() async {
    final savedUser = sharedPreferences.getString('user');
    if (savedUser != null) {
      return Future.value(UserModel.fromJson(json.decode(savedUser)));
    } else {
      throw Exception(notSignedInMessage);
    }
  }

  Future<bool> logout({required String language}) async {
    bool done = await removeData(key: 'user');
    return done && await removeData(key: 'token');
  }
}
