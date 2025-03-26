import 'package:flutter/material.dart';

class FluentRatingBar extends StatelessWidget {
  const FluentRatingBar({
    super.key,
    required this.width,
    required this.score,
    required this.colors,
    required this.start,
    required this.end,
    this.variation = 5,
    required this.numberColor,
  });

  final double width;
  final double score;
  final List<Color> colors;
  final Color numberColor;
  final int start, end, variation;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          start.toString(),
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              color: numberColor),
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            SizedBox(
              width: width * 0.1,
              height: 50,
              child: Stack(
                children: [
                  Positioned(
                    left: width * 0.08 * (((score + variation) / 10) * 100) / 100,
                    child: Column(
                      children: [
                        Text(
                          score.toStringAsFixed(1).toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: numberColor),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 30,
                          color: numberColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: width * 0.1,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: colors,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Text(
          end.toString(),
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              color: numberColor),
        ),
      ],
    );
  }
}
