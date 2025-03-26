import 'package:fluent_flow/core/const/styles.dart';
import 'package:fluent_flow/features/video_score/widgets/fluent_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainBarScoreWidget extends StatelessWidget {
  const MainBarScoreWidget({
    super.key,
    required this.name,
    required this.scoreName,
    required this.onTap,
    required this.score,
    required this.width,
    required this.colors,
    required this.start,
    required this.end,
  });

  final String name;
  final String scoreName;
  final double score;
  final int start, end;
  final double width;
  final Function onTap;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 22.0, color: fluentNavy),
        ),
        Text(
          scoreName,
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 45),
        FluentRatingBar(
          width: width,
          score: score,
          colors: colors,
          start: start,
          numberColor: Colors.blueGrey,
          end: end,
        ),
        const SizedBox(height: 45),
        InkWell(
          onTap: () {
            onTap();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "See more details",
                maxLines: 1,
                style: TextStyle(
                  color: fluentBlue,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.more, color: fluentBlue, size: 20.sp),
            ],
          ),
        )
      ],
    );
  }
}
