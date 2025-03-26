import 'package:flutter/material.dart';
import 'package:fluent_flow/core/const/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class ReviewBar extends StatefulWidget {
  ReviewBar({super.key, required this.height, required this.width, required this.selectedEndDate, required this.selectedStartDate, required this.onEndDateClicked, required this.onStartDateClicked});

  final double width, height;
  DateTime selectedStartDate, selectedEndDate;
  Function onStartDateClicked, onEndDateClicked;


  @override
  State<ReviewBar> createState() => _ReviewBarState();
}

class _ReviewBarState extends State<ReviewBar> {
  @override
  Widget build(BuildContext context) {
    double width = widget.width;
    return Container(
      width: width*0.8,
      height: 150.h,
      color: fluentLightBlue.withOpacity(0.45),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: width*0.02),
          Text(
            "Review Data from:",
            maxLines: 1,
            style: TextStyle(
              color: fluentNavy,
              fontWeight: FontWeight.bold,
              fontSize: 30.sp
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: fluentLightPurple,
            ),
            child: TextButton(
              onPressed: (){
                setState(() {
                  widget.onStartDateClicked();
                });
              },
              child: Text("${widget.selectedStartDate.toLocal()}".split(' ')[0], style: TextStyle(color: fluentWhite, fontWeight: FontWeight.bold)),
            ),
          ),
          Text(
            "to:",
            maxLines: 1,
            style: TextStyle(
              color: fluentNavy,
              fontWeight: FontWeight.bold,
              fontSize: 30.sp
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: fluentLightPurple,
            ),
            child: TextButton(
              onPressed: () {
                setState(() {
                  widget.onEndDateClicked();
                });
              },
              child: Text("${widget.selectedEndDate.toLocal()}".split(' ')[0], style: TextStyle(color: fluentWhite, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}