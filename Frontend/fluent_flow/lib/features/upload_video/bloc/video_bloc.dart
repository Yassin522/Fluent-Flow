import 'dart:async';
import 'dart:html' as html;

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'video_event.dart';
import 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc() : super(const VideoState()) {
    on<PickVideoEvent>(_onPickVideo);
    on<ToggleVideoEvent>(_onToggleVideo);
    on<ShowControlsEvent>(_onShowControls);
    on<HideControlsEvent>(_onHideControls);
  }

  Future<void> _onPickVideo(PickVideoEvent event, Emitter<VideoState> emit) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      PlatformFile file = result.files.first;

      final bytes = file.bytes;
      if (bytes != null) {
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);

        final controller = VideoPlayerController.networkUrl(Uri.parse(url));
        await controller.initialize();
        controller.play();

        emit(state.copyWith(controller: controller, videoBytes: bytes));
      }
    }
  }

void _onToggleVideo(ToggleVideoEvent event, Emitter<VideoState> emit) {
  if (state.controller != null) {
    if (state.controller!.value.isPlaying) {
      state.controller!.pause();
    } else {
      state.controller!.play();
    }

    print("Toggle video: isPlaying = ${state.controller!.value.isPlaying}");

    emit(state.copyWith(controller: state.controller));
  }
}



  void _onShowControls(ShowControlsEvent event, Emitter<VideoState> emit) {
    emit(state.copyWith(showControls: true));
  }

  void _onHideControls(HideControlsEvent event, Emitter<VideoState> emit) {
    emit(state.copyWith(showControls: false));
  }
}
