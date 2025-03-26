import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:fluent_flow/core/cache/cache_helper.dart';
import 'package:fluent_flow/features/login/domain/entities/login_response.dart';
import 'package:fluent_flow/features/login/domain/repositories/login_repo.dart';

import '../../../../core/const/failure_messages.dart';
import '../../../../core/entities/failure.dart';
import '../data_sources/login_remote_data_source.dart';

class LogInRepositoryImpl extends LogInRepository {
  
  final LogInRemoteDataSource remoteDataSource;
  final CacheHelper cacheHelper;

  LogInRepositoryImpl({required this.remoteDataSource, required this.cacheHelper});

  @override
  Future<Either<Failure, LogInResponse>> login({required String email, required String password}) async {
    try {
        final loginResponse = await remoteDataSource.login(
          email: email,
          password: password,
        );
        cacheHelper.saveUser(user: loginResponse.user);
        cacheHelper.getSavedUser();
        cacheHelper.saveData(key: 'token', value: loginResponse.token);
        return Right(loginResponse);
        // ignore: unused_catch_clause
    } on TimeoutException catch (e) {
        return const Left(Failure(message: timeOutMessage));
    } on Exception catch (e) {
      if (e.toString() == 'Exception: $wrongEmailOrPassword') {
        return const Left(Failure(message: wrongEmailOrPassword));
      }
      return Left(Failure(message: e.toString()));
    }
  }
}
