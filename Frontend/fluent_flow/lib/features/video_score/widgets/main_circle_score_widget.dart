import 'package:fluent_flow/core/const/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainCircleScoreWidget extends StatelessWidget {
  const MainCircleScoreWidget({
    super.key,
    required this.name,
    required this.scoreName,
    required this.onTap,
    required this.score,
  });

  final String name;
  final String scoreName;
  final double score;
  final Function onTap;

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
        const SizedBox(height: 25),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: score / 10,
                strokeWidth: 10,
                backgroundColor: Colors.amber[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.amber,
                ),
              ),
            ),
            Text(
              '${score.toStringAsFixed(1)}/10',
              style: TextStyle(
                fontSize: 35.sp,
                fontWeight: FontWeight.bold,
                color: fluentNavy,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
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