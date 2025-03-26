import 'package:dartz/dartz.dart';
import 'package:fluent_flow/features/login/domain/entities/login_response.dart';

import '../../../../core/entities/failure.dart';

abstract class LogInRepository {
  Future<Either<Failure, LogInResponse>> login({required String email, required String password});
}
