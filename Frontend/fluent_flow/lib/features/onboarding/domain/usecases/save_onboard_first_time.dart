import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fluent_flow/core/entities/usecase.dart';

import '../../../../core/entities/failure.dart';
import '../repositories/onboard_repo.dart';

class SaveOnBoardFirstTime extends UseCase<bool, SaveOnBoardFirstTimeParams>{
  final OnBoardRepository repository;

  SaveOnBoardFirstTime({required this.repository});

  @override
  Future<Either<Failure, bool>> call({required SaveOnBoardFirstTimeParams params}) async {
    return await repository.saveOnBoardFirstTime(firstTime: params.firstTime);
  }

}

class SaveOnBoardFirstTimeParams extends Equatable {
  final bool firstTime;

  const SaveOnBoardFirstTimeParams({required this.firstTime});

  @override
  List<Object> get props => [firstTime];
}