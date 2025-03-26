import 'package:fluent_flow/core/const/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SeeDetailsButton extends StatelessWidget {
  const SeeDetailsButton({
    super.key,
    required this.onTap
  });

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "See Video Scores",
            maxLines: 1,
            style: TextStyle(
                color: fluentBlue,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          Icon(Icons.more, color: fluentBlue, size: 20.sp),
        ],
      ),
    );
  }
}
