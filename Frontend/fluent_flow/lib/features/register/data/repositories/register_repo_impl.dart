import 'dart:async';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fluent_flow/features/register/data/data_sources/register_remote_source.dart';
import 'package:fluent_flow/features/register/domain/repositories/register_repo.dart';

import '../../../../core/const/failure_messages.dart';
import '../../../../core/entities/failure.dart';

class RegisterRepositoryImpl extends RegisterRepository{

  final RegisterRemoteDataSource remoteDataSource;

  RegisterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> register({
    required String email,
    required String job,
    required String password,
    required String name,
  }) async {
    try {
      await remoteDataSource.register(
        email: email,
        password: password,
        name: name,
        job: job
      );
      return const Right(null);
    } 
    on TimeoutException {
      log(timeOutMessage);
      return Left(Failure(message: timeOutMessage));
    }
    on Exception catch (e) {
      if (e.toString() == 'Exception: 409') {
        return Left(Failure(message: userExistMessage));
      }
      return Left(Failure(message: e.toString().substring(11)));
    }
  }
}