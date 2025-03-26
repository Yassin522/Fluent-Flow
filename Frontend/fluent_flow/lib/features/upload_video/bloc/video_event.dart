import 'package:equatable/equatable.dart';


abstract class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object?> get props => [];
}

class PickVideoEvent extends VideoEvent {}

class ToggleVideoEvent extends VideoEvent {}

class ShowControlsEvent extends VideoEvent {}

class HideControlsEvent extends VideoEvent {}
