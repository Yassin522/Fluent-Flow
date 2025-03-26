import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluent_flow/features/onboarding/domain/usecases/save_onboard_first_time.dart';

import '../../domain/usecases/get_onboard_info.dart';
import 'onborad_event.dart';
import 'onborad_state.dart';


class OnBoardBloc extends Bloc<OnBoardEvent, OnBoardState> {

  final GetOnBoardInfo getOnBoardInfo;
  final SaveOnBoardFirstTime saveOnBoardFirstTime;
  
  OnBoardBloc({required this.getOnBoardInfo, required this.saveOnBoardFirstTime}) : super(OnBoardInitial()) {
    on<OnBoardEvent>((event, emit) async {

      if(event is CacheOnBoardFirstTimeEvent) {
        emit(OnBoardLoadingState());
        var failureOrSaveOnBoardIndex = await saveOnBoardFirstTime(params: SaveOnBoardFirstTimeParams(firstTime: event.firstTime));
        await failureOrSaveOnBoardIndex.fold(
          (failure) async {
            emit(OnBoardErrorState(message: failure.message));
          },
          (saveOnBoardFirstTime) async {
            emit(SaveOnBoardFirstTimeSuccessState());
          } 
        );
      }   
    });
  }
}
