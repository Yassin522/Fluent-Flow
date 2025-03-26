import 'package:fluent_flow/core/const/styles.dart';
import 'package:fluent_flow/features/video_score/widgets/fluent_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DetailScoreWidget extends StatelessWidget {
  const DetailScoreWidget({
    super.key,
    required this.width,
    required this.height,
    required this.definition,
    required this.scoreInfo,
    required this.name,
    required this.svgName,
    required this.score,
    required this.colors,
    required this.start,
    required this.end,
    this.variation = 5,
  });

  final double width;
  final double height;
  final String name;
  final String svgName;
  final String definition;
  final String scoreInfo;
  final double score;
  final int start, end;
  final List<Color> colors;
  final int variation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.2,
      height: height * 0.8,
      decoration: BoxDecoration(
        color: fluentPurple.withOpacity(0.9),
        border: Border.all(color: fluentNavy, width: 4),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svgName,
            width: 40,
            height: 40,
            color: Colors.white,
          ),
          Text(
            name,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22.0,
                color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            definition,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          FluentRatingBar(
            width: width,
            numberColor: Colors.white,
            score: score,
            colors: colors,
            start: start,
            variation: variation,
            end: end,
          ),
          const SizedBox(height: 30),
          Text(
            scoreInfo,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
