import 'package:fluent_flow/core/const/styles.dart';
import 'package:fluent_flow/core/models/video_model.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_cubit.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_states.dart';
import 'package:fluent_flow/features/video_score/widgets/detail_analytics_widget.dart';
import 'package:fluent_flow/features/video_score/widgets/detail_score_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GesturesScorePage extends StatelessWidget {
  static const String routeName = 'gestures_score_page';

  const GesturesScorePage({super.key, required this.video});

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
                      height: height * 0.26,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100)),
                        image: DecorationImage(
                          image: AssetImage('assets/images/Frame 21.jpg'),
                          fit: BoxFit.fitWidth,
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
                          Text(
                            "Gestures Evaluation Results",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                                color: fluentPurple),
                          ),
                          SizedBox(height: height * 0.01),
                          const Text(
                            "Evaluating your body language and gestures to ensure they complement\nand reinforce your verbal message",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22.0,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: height * 0.05),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: fluentNavy, width: 3),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Gestures Scores",
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
                                svgName: "assets/icons/body-svgrepo-com.svg",
                                name: "Gesture Use Score",
                                definition:
                                    "A measure of how effectively the speaker uses gestures to complement and emphasize their speech",
                                scoreInfo:
                                    "-5 (the presenter isn't using any gestures)\n0 (good use of gesture)\n5 (the gestures are distracting/too much)",
                                width: width,
                                height: height,
                                score: video.gestureUseScore!,
                                start: -5,
                                colors: const [
                                  Colors.red,
                                  Colors.green,
                                  Colors.red,
                                ],
                                end: 5,
                              ),
                              DetailScoreWidget(
                                name: "Eye Gaze Score",
                                svgName: "assets/icons/eye-svgrepo-com.svg",
                                definition:
                                    "A measure of how effectively the speaker uses eye contact to connect with the audience",
                                scoreInfo:
                                    "0 (the presenter isn't engaging with the audience (ex: looking away or down)\n5 (the presenter is engaging in a good way)",
                                width: width,
                                height: height,
                                score: video.eyeGazeScore!,
                                start: 0,
                                colors: const [
                                  Colors.red,
                                  Colors.yellow,
                                  Colors.green,
                                ],
                                end: 5,
                              ),
                              DetailScoreWidget(
                                name: "Head Gaze Score",
                                svgName: "assets/icons/head-svgrepo-com.svg",
                                definition:
                                    "A measure of how effectively the speaker's head movements align with their gaze and speech, contributing to communication effectiveness",
                                scoreInfo:
                                    "0 (the presenter isn't engaging with the audience (ex: looking away or down)\n5 (the presenter is engaging in a good way)",
                                width: width,
                                height: height,
                                score: video.headGazeScore!,
                                start: 0,
                                colors: const [
                                  Colors.red,
                                  Colors.yellow,
                                  Colors.green,
                                ],
                                end: 5,
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.05),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: fluentNavy, width: 3),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Gestures Analytics",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28.0,
                                      color: fluentNavy),
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.stacked_line_chart_rounded,
                                  color: fluentNavy,
                                  size: 35,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: height * 0.05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DetailAnalyticsWidget(
                                svgName: "assets/icons/body-svgrepo-com.svg",
                                name: "Gesture Place",
                                definition:
                                    "The percentage of time your gestures where near your face. When presenting you should aren’t far away from your face so the person watching you don't get distracted",
                                scoreInfo:
                                    "percentage of the whole presentation",
                                width: width,
                                height: height,
                                score: video.gesturePlaceScore! / 10,
                              ),
                              DetailAnalyticsWidget(
                                name: "Gesture Close",
                                svgName: "assets/icons/body-svgrepo-com.svg",
                                definition:
                                    "The percentage of time the speaker’s gestures are appropriately close to the body, typically indicating controlled and intentional movement",
                                scoreInfo:
                                    "percentage of the whole presentation",
                                width: width,
                                height: height,
                                score: video.gestureClosePercentage! / 10,
                              ),
                              DetailAnalyticsWidget(
                                name: "Good Poses",
                                svgName:
                                    "assets/icons/basic-figure-with-arms-up-svgrepo-com.svg",
                                definition:
                                    "The percentage of time the speaker maintains a good posture or stance, which can convey confidence and professionalism",
                                scoreInfo:
                                    "percentage of the whole presentation",
                                width: width,
                                height: height,
                                score: video.goodPosesPercentage! / 10,
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DetailAnalyticsWidget(
                                svgName:
                                    "assets/icons/basic-figure-with-arms-up-svgrepo-com.svg",
                                name: "Bad Poses\n(Hands On Hips)",
                                definition:
                                    "The percentage of time the speaker's hands are on their hips, which can be perceived as aggressive or defensive",
                                scoreInfo:
                                    "percentage of the whole presentation",
                                width: width,
                                height: height,
                                score:
                                    video.badPosesPercentageHandsOnHips! / 10,
                              ),
                              DetailAnalyticsWidget(
                                name: "Bad Poses\n(Hands Crossed)",
                                svgName:
                                    "assets/icons/body-balance-svgrepo-com.svg",
                                definition:
                                    "The percentage of time the speaker's hands crossed, which can be perceived as aggressive or defensive",
                                scoreInfo:
                                    "percentage of the whole presentation",
                                width: width,
                                height: height,
                                score:
                                    video.badPosesPercentageHandsCrossed! / 10,
                              ),
                              DetailAnalyticsWidget(
                                name: "Gaze Ratio",
                                svgName: "assets/icons/head-svgrepo-com.svg",
                                definition:
                                    "The percentage of time the speaker maintains proper eye contact, which is key for engaging the audience",
                                scoreInfo:
                                    "percentage of the whole presentation",
                                width: width,
                                height: height,
                                score: video.gazeRatioPercentage! / 10,
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
