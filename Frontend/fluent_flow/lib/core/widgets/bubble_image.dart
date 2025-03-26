import 'package:fluent_flow/core/const/styles.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class BubbleImage extends StatelessWidget {
  BubbleImage({
    super.key,
    required this.width,
    required this.height,
    required this.imageProvider,
    this.edit = false,
    this.onEdit,
  });

  final double width;
  final double height;
  final ImageProvider imageProvider;
  final bool edit;
  Function? onEdit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/image_2024-06-23_23-48-29.png',
          width: width * 0.38,
          height: height * 0.38,
        ),
        Image.asset(
          'assets/images/image_2024-06-23_23-48-19.png',
          width: width * 0.38,
          height: height * 0.3,
        ),
        Image.asset(
          'assets/images/image_2024-06-23_23-48-08.png',
          width: width * 0.38,
          height: height * 0.2,
        ),
        const CircleAvatar(
          radius: 83,
          backgroundColor: Colors.white,
        ),
        Stack(
          alignment: Alignment.topRight,
          children: [
            CircleAvatar(
              radius: 80,
              foregroundImage: imageProvider,
            ),
            if(edit) InkWell(
              child: CircleAvatar(
                backgroundColor: fluentWhite,
                child: Icon(Icons.edit_rounded, color: fluentBlue),
              ),
              onTap: (){
                onEdit!();
              },
            ),
          ],
        ),
      ],
    );
  }
}
