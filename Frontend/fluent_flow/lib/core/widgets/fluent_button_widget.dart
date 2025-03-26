
import 'package:flutter/material.dart';

import '../const/styles.dart';

class ExpoButton extends StatelessWidget {
  const ExpoButton({
    Key? key,
    required this.function,
    required this.text,
    this.color = const Color(0xffe1372d),
  }) : super(key: key);

  final Function function;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          splashFactory: NoSplash.splashFactory),
      onPressed: () {
        function();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: fluentWhite, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
