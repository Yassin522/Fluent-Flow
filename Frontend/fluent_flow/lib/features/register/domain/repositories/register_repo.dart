import 'package:dartz/dartz.dart';
import 'package:fluent_flow/core/entities/failure.dart';

abstract class RegisterRepository {

  Future<Either<Failure, void>> register({
    required String email,
    required String password,
    required String name,
    required String job,
  });
}