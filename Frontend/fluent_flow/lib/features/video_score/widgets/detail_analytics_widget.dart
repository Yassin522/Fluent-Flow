import 'package:fluent_flow/core/const/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DetailAnalyticsWidget extends StatelessWidget {
  const DetailAnalyticsWidget({
    super.key,
    required this.width,
    required this.height,
    required this.definition,
    required this.scoreInfo,
    required this.name,
    required this.svgName,
    required this.score,
  });

  final double width;
  final double height;
  final String name;
  final String svgName;
  final String definition;
  final String scoreInfo;
  final double score;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.2,
      height: height * 0.8,
      decoration: BoxDecoration(
        color: fluentBlue.withOpacity(0.9),
        border: Border.all(color: fluentNavy, width: 4),
        borderRadius: BorderRadius.circular(60),
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
            textAlign: TextAlign.center,
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
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: fluentNavy,
                ),
              ),
            ],
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
