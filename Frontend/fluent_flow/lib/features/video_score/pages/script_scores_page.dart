import 'package:fluent_flow/core/const/styles.dart';
import 'package:fluent_flow/core/models/video_model.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_cubit.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_states.dart';
import 'package:fluent_flow/features/video_score/widgets/analytics_widget.dart';
import 'package:fluent_flow/features/video_score/widgets/detail_score_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScriptXScorePage extends StatelessWidget {
  static const String routeName = 'script_score_pagex';

  const ScriptXScorePage({super.key, required this.video});
  
  final Video video;

  double scoreLanguageVariation(totalTokens, uniqueTokens){
    double  ratio = uniqueTokens / totalTokens;
    if (ratio >= 0.5) {
      return 0.0;
    }
    else if (ratio <= 0.15) {
      return 5.0;
    }
    else{
      double score = 4 - ((ratio - 0.15) / (0.5 - 0.15)) * 3;
      return score;
    }
  }

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
                            "Script Evaluation Results",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                                color: fluentPurple),
                          ),
                          SizedBox(height: height * 0.01),
                          const Text(
                            "Analyzing the clarity and structure of your spoken content to ensure your message is effectively communicated",
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
                                  "Script Scores",
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
                                svgName: "assets/icons/script-1604-svgrepo-com.svg",
                                name: "Script Total Score",
                                definition: "A combined score representing the overall quality of the script, considering various factors like clarity, structure, and grammar",
                                scoreInfo: "0 (the script too bad)\n10 (excellent script)",
                                width: width, height: height,
                                score: video.scriptTotalScore!,
                                start: 0,
                                variation: 0,
                                colors: const [
                                  Colors.red,
                                  Colors.green,
                                ],
                                end: 10,
                              ),
                              DetailScoreWidget(
                                svgName: "assets/icons/script-1604-svgrepo-com.svg",
                                name: "Language Variation Score",
                                definition: "the diversity and variety of vocabulary that used",
                                scoreInfo: "0 (poor language) 5 (too variate)",
                                width: width, height: height,
                                score: scoreLanguageVariation(video.tokensCount!, video.uniqueTokensCount!),
                                start: 0,
                                variation: 0,
                                colors: const [
                                  Colors.red,
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
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Script Analytics",
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
                              AnalyticsWidget(
                                svgName: "assets/icons/script-1604-svgrepo-com.svg",
                                name: "Unique Words Count",
                                definition: "The number of distinct words or phrases used in the script, indicating lexical variety",
                                width: width, height: height,
                                score: video.uniqueTokensCount!*1.0,
                              ),
                              AnalyticsWidget(
                                name: "Words Count",
                                svgName: "assets/icons/script-1604-svgrepo-com.svg",
                                definition: "The total number of words or tokens in the script, providing a measure of script length",
                                width: width, height: height,
                                score: video.tokensCount!*1.0,
                              ),
                              AnalyticsWidget(
                                name: "Stop Word Count",
                                svgName: "assets/icons/stop-circle-svgrepo-com.svg",
                                definition: "The number of common words (like \"and,\" \"the,\" \"uh\") that usually carry less meaning and are often excluded from key analyses",
                                width: width, height: height,
                                score: video.stopWordsCount!*1.0,
                              ),
                              AnalyticsWidget(
                                name: "Sentences Count",
                                svgName: "assets/icons/script-1604-svgrepo-com.svg",
                                definition: "The total number of sentences in the script, indicating the script's structure and flow",
                                width: width, height: height,
                                score: video.sentencesCount!*1.0,
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(video.sentenceLengthScore != null) AnalyticsWidget(
                                name: "Sentence Length Average",
                                svgName: "assets/icons/language-svgrepo-com.svg",
                                definition: "A measure of the average length of sentences, with a balance between short and long sentences generally being ideal",
                                width: width, height: height,
                                score: video.sentenceLengthScore!,
                              ),
                              AnalyticsWidget(
                                name: "Grammar Error",
                                svgName: "assets/icons/grammar-class-teacher-teaching-pointing-whiteboard-text-lines-svgrepo-com.svg",
                                definition: "Number of the grammatical mistakes",
                                // scoreInfo: "0 (the grammar mistakes aren't noticeable)\n5 (there are a lot of grammar mistakes and they are distracting)",
                                width: width, height: height,
                                score: video.grammarScore!,
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

