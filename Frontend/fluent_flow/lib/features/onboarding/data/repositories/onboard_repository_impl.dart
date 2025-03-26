import 'package:dartz/dartz.dart';

import '../../../../core/entities/failure.dart';
import '../../domain/entities/onboard_response.dart';
import '../../domain/repositories/onboard_repo.dart';
import '../data_sources/onboard_local_data_source.dart';

class OnBoardRepositoryImpl extends OnBoardRepository {
  final OnBoardLocalDataSource localDataSource;

  OnBoardRepositoryImpl({required this.localDataSource});

    @override
  Future<Either<Failure, OnBoard>> getOnBoard() async {
    try {
      OnBoard onBoard = await localDataSource.getOnBoard();
      return Right(onBoard);
    } on Exception catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> saveOnBoardFirstTime({required bool firstTime}) async {
    try {
      bool done = await localDataSource.saveOnBoardFirstTime(firstTime: firstTime);
      return Right(done);
    } on Exception catch (e) {
      return Left(Failure(message: e.toString().substring(11)));
    }
  }

}
