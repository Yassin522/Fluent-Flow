import 'package:fluent_flow/core/const/styles.dart';
import 'package:fluent_flow/core/models/video_model.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_cubit.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_states.dart';
import 'package:fluent_flow/features/video_score/widgets/detail_score_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoiceScorePage extends StatelessWidget {
  static const String routeName = 'voice_score_page';

  const VoiceScorePage({super.key, required this.video});
  
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
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      height: height*0.22,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100), bottomRight: Radius.circular(100)),
                        image: DecorationImage(
                          image: AssetImage('assets/images/Frame 21.jpg'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: BackButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )),
                          Text(
                            "Voice Evaluation Results",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                                color: fluentPurple),
                          ),
                          SizedBox(height: height * 0.01),
                          const Text(
                            "Assessing the tone, pace, and variation in your speech to enhance engagement and convey confidence",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22.0,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: height * 0.07),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: fluentNavy, width: 3),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Voice Scores",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28.0,
                                      color: fluentNavy),
                                ),
                                Icon(
                                  Icons.sports_score_rounded,
                                  color: fluentNavy,
                                  size: 40,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: height * 0.05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DetailScoreWidget(
                                svgName: "assets/icons/sad-alt-2-svgrepo-com.svg",
                                name: "Filler Words Score",
                                definition: "A score that reflects the frequency of filler words like \"um,\" \"uh,\" or \"like,\" which can detract from the clarity of speech",
                                scoreInfo: "0 (the filler words aren't distracting)\n5 (there are a lot of filler words and that they are distracting)",
                                width: width, height: height,
                                score: video.fillerWordsScore!,
                                start: 0,
                                colors: const [
                                  Colors.red,
                                  Colors.green,
                                ],
                                end: 5,
                              ),
                              DetailScoreWidget(
                                name: "Speed/Pace Score",
                                svgName: "assets/icons/voice-square-svgrepo-com.svg",
                                definition: "A measure of the pace at which the speaker talks, indicating whether the speech is too fast, too slow, or at an appropriate speed",
                                scoreInfo: "-5 (means too slow)\n0 (perfect or optimal)\n5 (means too fast)",
                                width: width, height: height,
                                score: video.speedPaceScore!,
                                start: -5,
                                colors: const [
                                  Colors.red,
                                  Colors.green,
                                  Colors.red,
                                ],
                                end: 5,
                              ),
                              DetailScoreWidget(
                                name: "Speed Variation Score",
                                svgName: "assets/icons/voice-activate-svgrepo-com.svg",
                                definition: "A measure of how much the speaking speed varies, with some variation typically being beneficial for engagement",
                                scoreInfo: "-5 (too monotonic)\n0 (optimal or perfect)\n5 (too varying)",
                                width: width, height: height,
                                score: video.voiceVariationScore!,
                                start: -5,
                                colors: const [
                                  Colors.red,
                                  Colors.green,
                                  Colors.red,
                                ],
                                end: 5,
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DetailScoreWidget(
                                svgName: "assets/icons/pause-svgrepo-com.svg",
                                name: "Pausing Score",
                                definition: "A score that indicates the effectiveness of pauses during speech, which can enhance comprehension and emphasize key points",
                                scoreInfo: "-5 (the person is pausing too much)\n0 (good / optimal)\n5 (the person isn't pausing at all)",
                                width: width, height: height,
                                score: video.pauseScore!,
                                start: -5,
                                colors: const [
                                  Colors.red,
                                  Colors.green,
                                  Colors.red,
                                ],
                                end: 5,
                              ),
                              DetailScoreWidget(
                                name: "Vocal Variation",
                                svgName: "assets/icons/voice-square-svgrepo-com.svg",
                                definition: "dynamics of pitch changes in a speaker's voice throughout their speech. It reflects the energy and expressiveness a speaker brings to their presentation, contributing to the overall engagement and liveliness of their delivery",
                                scoreInfo: "-5 (no variation at all)\n0 (perfect or optimal)\n5 (too much variation)",
                                width: width, height: height,
                                score: video.vocalVariationScore!,
                                start: -5,
                                colors: const [
                                  Colors.red,
                                  Colors.green,
                                  Colors.red,
                                ],
                                end: 5,
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.05),
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

