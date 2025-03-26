import 'package:equatable/equatable.dart';
import 'dart:typed_data';
import 'package:video_player/video_player.dart';

class VideoState extends Equatable {
  final VideoPlayerController? controller;
  final Uint8List? videoBytes;
  final bool showControls;

  const VideoState({
    this.controller,
    this.videoBytes,
    this.showControls = false,
  });

  VideoState copyWith({
    VideoPlayerController? controller,
    Uint8List? videoBytes,
    bool? showControls,
  }) {
    return VideoState(
      controller: controller ?? this.controller,
      videoBytes: videoBytes ?? this.videoBytes,
      showControls: showControls ?? this.showControls,
    );
  }

  @override
  List<Object?> get props => [controller, videoBytes, showControls];
}
