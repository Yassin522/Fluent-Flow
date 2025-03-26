import 'package:fluent_flow/features/upload_video/pages/video_player.dart';
import 'package:fluent_flow/features/video_score/pages/video_score_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_cubit.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_states.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart'; // Add this import

import '../../../core/const/styles.dart';
import '../../../core/models/video_model.dart';

class VideoPage extends StatelessWidget {
  static const String routeName = 'video_page';

  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FluentCubit(),
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          double height = constraints.maxHeight;
          double width = constraints.maxWidth;
          return Stack(
            children: [
              Container(
                height: height,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Frame 21.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.12),
                        BlocBuilder<FluentCubit, FluentState>(
                          builder: (context, state) {
                            if ((state is VideoPickedState ||
                                    state is EvaluateVideoLoadingState) &&
                                state.controller != null) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: width * 0.5,
                                    height: height * 0.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: fluentNavy,
                                          spreadRadius: 5,
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: VideoPlayerWidget(
                                          controller: state.controller!),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Container(
                                  width: width * 0.5,
                                  height: height * 0.5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    border: Border.all(
                                      color: Colors.grey[400]!,
                                      width: 2,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        spreadRadius: 5,
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.video_library,
                                          size: 50,
                                          color: Colors.grey[700],
                                        ),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Text(
                                            'No video selected',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(height: height * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(15)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                context.read<FluentCubit>().pickVideo();
                              },
                              icon: const Icon(Icons.video_library),
                              label: const Text('Pick Video'),
                            ),
                            BlocBuilder<FluentCubit, FluentState>(
                              builder: (context, state) {
                                if (state is VideoPickedState ||
                                    state is EvaluateVideoLoadingState ||
                                    state is ShowControlsState ||
                                    state is HideControlsState) {
                                  return Row(
                                    children: [
                                      SizedBox(width: width * 0.05),
                                      ElevatedButton.icon(
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<
                                                  EdgeInsets>(
                                              const EdgeInsets.all(15)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          final cubit = context.read<FluentCubit>();
                                          print(cubit.controller);
                                          print(cubit.controller!.value.isInitialized);
                                          if (cubit.controller != null && cubit.controller!.value.isInitialized) {
                                            final state = context.read<FluentCubit>().state;
                                            if (state is VideoPickedState) {
                                              cubit.evaluateVideo(state.videoFile); // Pass the video file
                                            }
                                          }
                                        },
                                        icon: const Icon(Icons.play_arrow_rounded),
                                        label: const Text('Start Evaluation'),
                                      ),
                                    ],
                                  );
                                }
                                return Container();
                              },
                            ),
                          ],
                        ),
                        BlocConsumer<FluentCubit, FluentState>(
                          listener: (context, state) {
                            if(state is EvaluateVideoSuccessState){
                              if(FluentCubit.get(context).videoScore == null){
                                print("ERROR NULL");
                              }
                              else{
                                Video video = FluentCubit.get(context).videoScore!;
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => VideoScorePage(video: video),
                                ));
                              }
                            } 
                          },
                          builder: (context, state) {
                            if (state is EvaluateVideoLoadingState) {
                              return Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.white,
                                  size: 200,
                                ),
                              );
                            } else if (state is EvaluateVideoErrorState) {
                              return Text('Error: ${state.message}');
                            }
                            return Container();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 15,
                right: 40,
                child: Image.asset(
                  'assets/images/new_logo.png',
                  width: 130,
                  height: 130,
                ),
              ),
              Positioned(
                top: 35,
                left: 40,
                child: BackButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  String getSvgIconForKey(String key) {
    switch (key) {
      case 'speed_pace':
        return 'assets/icons/voice-square-svgrepo-com.svg';
      case 'voice_variation':
        return 'assets/icons/voice-square-svgrepo-com.svg';
      case 'pausing':
        return 'assets/icons/pause-svgrepo-com.svg';
      case 'filler_words':
        return 'assets/icons/sad-alt-2-svgrepo-com.svg';
      case 'grammar':
        return 'assets/icons/grammar-class-teacher-teaching-pointing-whiteboard-text-lines-svgrepo-com.svg';

      case 'language_variation':
        return 'assets/icons/language-svgrepo-com.svg';

      case 'script':
        return 'assets/icons/script-1604-svgrepo-com.svg';

      case 'eye_contact_head_gaze':
        return 'assets/icons/eye-svgrepo-com.svg';

      case 'gesture_use':
        return 'assets/icons/body-svgrepo-com.svg';

      case 'video':
        return 'assets/icons/body-balance-svgrepo-com.svg';

      default:
        return 'assets/icons/body-balance-svgrepo-com.svg';
    }
  }
}
