import 'package:dartz/dartz.dart';

import 'package:fluent_flow/core/entities/usecase.dart';
import 'package:fluent_flow/features/onboarding/domain/entities/onboard_response.dart';

import '../../../../core/entities/failure.dart';
import '../repositories/onboard_repo.dart';

class GetOnBoardInfo extends UseCase<OnBoard, NoParams>{
  final OnBoardRepository repository;

  GetOnBoardInfo({required this.repository});

  @override
  Future<Either<Failure, OnBoard>> call({required NoParams params}) async {
    return await repository.getOnBoard();
  }

}
