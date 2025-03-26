import 'package:equatable/equatable.dart';

abstract class OnBoardEvent extends Equatable {
  @override
  List<Object> get props => [];
}



class CacheOnBoardFirstTimeEvent extends OnBoardEvent {
  final bool firstTime;

  CacheOnBoardFirstTimeEvent({required this.firstTime});

  @override
  List<Object> get props => [firstTime];
}

