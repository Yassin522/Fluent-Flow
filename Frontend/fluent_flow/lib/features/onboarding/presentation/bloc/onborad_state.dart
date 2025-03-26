import 'package:equatable/equatable.dart';

abstract class OnBoardState extends Equatable {
  const OnBoardState();
  
  @override
  List<Object> get props => [];
}

class OnBoardInitial extends OnBoardState {}

class OnBoardLoadingState extends OnBoardState {}

class SaveOnBoardFirstTimeSuccessState extends OnBoardState {}
class OnBoardErrorState extends OnBoardState {
  final String message;
  const OnBoardErrorState({required this.message});
  
  @override
  List<Object> get props => [message];
}
