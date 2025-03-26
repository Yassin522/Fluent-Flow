import 'package:fluent_flow/core/cache/cache_helper.dart';
import 'package:fluent_flow/features/onboarding/domain/entities/onboard_response.dart';

abstract class OnBoardLocalDataSource {
  Future<OnBoard> getOnBoard();

  Future<bool> saveOnBoardFirstTime({required bool firstTime});
}

const cachedOnBoardFirstTime = 'CACHED_ONBOARD_FIRST_TIME';

class OnBoardLocalDataSourceImpl implements OnBoardLocalDataSource {
  
  final CacheHelper cacheHelper;

  OnBoardLocalDataSourceImpl({required this.cacheHelper});

  @override
  Future<OnBoard> getOnBoard() {
    final firstTime = cacheHelper.sharedPreferences.getBool(cachedOnBoardFirstTime);
    if (firstTime != null) {
      return Future.value(OnBoard(firstTime: firstTime));
    } else{
      throw Exception('error loading last onboard');
    }
  }

  @override
  Future<bool> saveOnBoardFirstTime({required bool firstTime}) async {
    return await cacheHelper.saveData(key: cachedOnBoardFirstTime, value: firstTime);
  }

}
