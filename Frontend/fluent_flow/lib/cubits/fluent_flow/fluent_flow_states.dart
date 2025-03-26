import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

import '../../core/entities/user.dart';
import 'dart:html' as html;

abstract class FluentState extends Equatable {
  const FluentState();
  
  @override
  List<Object> get props => [];

  get controller => null;
}

class FluentInitial extends FluentState {}

class GetUserLoadingState extends FluentState {}

class GetUserSuccessState extends FluentState {
  final User user;
  const GetUserSuccessState({required this.user});
}

class GetUserErrorState extends FluentState {
  final String message;
  const GetUserErrorState({required this.message});
  
  @override
  List<Object> get props => [message];
}

class LogoutLocalLoadingState extends FluentState {}

class LogoutLocalSuccessState extends FluentState {}

class LogoutLocalErrorState extends FluentState {
  final String message;
  const LogoutLocalErrorState({required this.message});
  
  @override
  List<Object> get props => [message];
}

class UpdateUserLoadingState extends FluentState {}

class UpdateUserSuccessState extends FluentState {
  const UpdateUserSuccessState();
}

class UpdateUserErrorState extends FluentState {
  final String message;
  const UpdateUserErrorState({required this.message});
  
  @override
  List<Object> get props => [message];
}

class ChangePasswordLoadingState extends FluentState {}

class ChangePasswordSuccessState extends FluentState {
  const ChangePasswordSuccessState();
}

class ChangePasswordErrorState extends FluentState {
  final String message;
  const ChangePasswordErrorState({required this.message});
  
  @override
  List<Object> get props => [message];
}

class AddPhotoLoadingState extends FluentState {}

class AddPhotoSuccessState extends FluentState {
  const AddPhotoSuccessState();
}

class AddPhotoErrorState extends FluentState {
  final String message;
  const AddPhotoErrorState({required this.message});
  
  @override
  List<Object> get props => [message];
}

class GetScoresLoadingState extends FluentState {}

class GetScoresSuccessState extends FluentState {
  const GetScoresSuccessState();
}

class GetScoresErrorState extends FluentState {

  final String message;
  const GetScoresErrorState({required this.message});
  
  @override
  List<Object> get props => [message];
}

class GetVideosLoadingState extends FluentState {}

class GetVideosSuccessState extends FluentState {
  const GetVideosSuccessState();
}

class GetVideosErrorState extends FluentState {

  final String message;
  const GetVideosErrorState({required this.message});
}

class VideoPickedState extends FluentState {
  final VideoPlayerController? controller;
  final html.File videoFile;

  const VideoPickedState({required this.controller, required this.videoFile});
  
  @override
  List<Object> get props => [controller!, videoFile];
}

class VideoToggledState extends FluentState {
  final VideoPlayerController? controller;
  
  const VideoToggledState({required this.controller});
  
  @override
  List<Object> get props => [controller!];
}

class ShowControlsState extends FluentState {}

class HideControlsState extends FluentState {}

class EvaluateVideoLoadingState extends FluentState {}

class EvaluateVideoSuccessState extends FluentState {
  const EvaluateVideoSuccessState();
  
  @override
  List<Object> get props => [];
}

class EvaluateVideoErrorState extends FluentState {
  final String message;
  const EvaluateVideoErrorState({required this.message});
  
  @override
  List<Object> get props => [message];
}


class GetVideoScoresLoadingState extends FluentState {}

class GetVideoScoresSuccessState extends FluentState {
  const GetVideoScoresSuccessState();
}

class GetVideoScoresErrorState extends FluentState {

  final String message;
  const GetVideoScoresErrorState({required this.message});
}

class EvaluateScriptLoadingState extends FluentState {}

class EvaluateScriptSuccessState extends FluentState {
  const EvaluateScriptSuccessState();
}

class EvaluateScriptErrorState extends FluentState {

  final String message;
  const EvaluateScriptErrorState({required this.message});
}
