import 'package:fluent_flow/core/const/api.dart';
import 'package:fluent_flow/core/const/styles.dart';
import 'package:fluent_flow/core/models/video_model.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_cubit.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_states.dart';
import 'package:fluent_flow/features/library/widgets/video_widget.dart';
import 'package:fluent_flow/features/video_score/pages/gestures_scores_page.dart';
import 'package:fluent_flow/features/video_score/pages/script_scores_page.dart';
import 'package:fluent_flow/features/video_score/pages/voice_scores_page.dart';
import 'package:fluent_flow/features/video_score/widgets/main_bar_score_widget.dart';
import 'package:fluent_flow/features/video_score/widgets/main_circle_score_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class VideoScorePage extends StatelessWidget {
  static const String routeName = 'video_score_page';

  const VideoScorePage({super.key, required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        double height = MediaQuery.sizeOf(context).height;
        double width = MediaQuery.sizeOf(context).width;
        return Scaffold(
          body: BlocConsumer<FluentCubit, FluentState>(
            listener: (context, state) {},
            builder: (context, state) {
              return state is GetVideoScoresLoadingState
                  ? Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: fluentNavy,
                        size: 200,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Stack(
                        children: [
                          Container(
                            height: height * 0.2,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/Frame 21.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                            child: Column(
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: BackButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: width * 0.4,
                                      height: height * 0.4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: fluentNavy,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: InkWell(
                                            child: VideoPlayerWidget(
                                                videoUrl:
                                                    IP_PORT + video.videoUrl!)),
                                      ),
                                    ),
                                    Container(
                                      width: width * 0.4,
                                      height: height * 0.4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: fluentLighterPurple,
                                        border: Border.all(
                                            color: fluentNavy, width: 2),
                                      ),
                                      padding: const EdgeInsets.all(18),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Transcription",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 28.0,
                                                  color: fluentNavy),
                                            ),
                                            Text(
                                              video.transcription!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: height * 0.05),
                                Text(
                                  "Your AI-Powered Presentation Performance Report",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28.0,
                                      color: fluentNavy),
                                ),
                                const Text(
                                  "Here’s how you performed across key presentation skills",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22.0,
                                      color: Colors.blueGrey),
                                ),
                                SizedBox(height: height * 0.05),
                                SizedBox(height: height * 0.05),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MainBarScoreWidget(
                                        name: "Gestures Evaluation Results",
                                        scoreName: "gesture use score:",
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => GesturesScorePage(video: video),
                                          ));
                                        },
                                        start: 0,
                                        end: 5,
                                        colors: const [
                                          Colors.red,
                                          Colors.yellow,
                                          Colors.green,
                                        ],
                                        width: width,
                                        score: video.gestureUseScore!),
                                    Container(width: 5, height: 200, decoration: BoxDecoration(
                                      color: fluentNavy,
                                      borderRadius: BorderRadius.circular(20),
                                    ),),
                                    MainBarScoreWidget(
                                        name: "Voice Evaluation Results",
                                        scoreName: "voice variation score:",
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => VoiceScorePage(video: video),
                                          ));
                                        },
                                        width: width,
                                        colors: const [
                                          Colors.redAccent,
                                          Colors.green,
                                          Colors.redAccent,
                                        ],
                                        start: -5,
                                        end: 5,
                                        score: video.voiceVariationScore!),
                                    Container(width: 5, height: 200, decoration: BoxDecoration(
                                      color: fluentNavy,
                                      borderRadius: BorderRadius.circular(20),
                                    ),),
                                    MainCircleScoreWidget(
                                        name: "Script Evaluation Results",
                                        scoreName: "script total score",
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => ScriptXScorePage(video: video),
                                          ));
                                        },
                                        score: video.scriptTotalScore!),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
        );
      }),
    );
  }
}