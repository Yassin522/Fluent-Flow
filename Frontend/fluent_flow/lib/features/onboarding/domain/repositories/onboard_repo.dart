import 'package:dartz/dartz.dart';
import 'package:fluent_flow/features/onboarding/domain/entities/onboard_response.dart';

import '../../../../core/entities/failure.dart';

abstract class OnBoardRepository {
  Future<Either<Failure, OnBoard>> getOnBoard();

  Future<Either<Failure, bool>> saveOnBoardFirstTime({required bool firstTime});
}
