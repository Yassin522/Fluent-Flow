import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {

  final double size;
  final double stroke;
  final Color? color;

  const LoadingWidget({Key? key, required this.size, required this.stroke, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: stroke,
        color: color?? Theme.of(context).iconTheme.color,
      ),
    );
  }
}