import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fluent_flow/core/entities/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call({required Params params});
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

