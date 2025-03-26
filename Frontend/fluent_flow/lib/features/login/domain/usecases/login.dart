import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fluent_flow/core/entities/usecase.dart';
import 'package:fluent_flow/features/login/domain/entities/login_response.dart';
import 'package:fluent_flow/features/login/domain/repositories/login_repo.dart';

import '../../../../core/entities/failure.dart';

class Login extends UseCase<LogInResponse, LoginParams>{
  final LogInRepository repository;

  Login({required this.repository});

  @override
  Future<Either<Failure, LogInResponse>> call({required LoginParams params}) async {
    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }

}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  
  @override
  List<Object?> get props => [email, password];
}
