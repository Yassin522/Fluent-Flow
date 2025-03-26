import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fluent_flow/core/entities/usecase.dart';
import 'package:fluent_flow/features/register/domain/repositories/register_repo.dart';
import '../../../../core/entities/failure.dart';

class Register extends UseCase<void, RegisterParams> {

  final RegisterRepository repository;

  Register({required this.repository});

  @override
  Future<Either<Failure, void>> call(
      {required RegisterParams params}) async {
    return await repository.register(
      email: params.email,
      name: params.name,
      password: params.password,
      job: params.job,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String name;
  final String job;

  const RegisterParams({required this.name, required this.email, required this.password, required this.job});

  @override
  List<Object?> get props => [name, email, password, job];
}