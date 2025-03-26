import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/models/onboard_item_modele.dart';

// ignore: non_constant_identifier_names
Widget OnBoardPageView(OnBoardItemModel model) => Column(
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: model.image.substring(model.image.length -3) == 'svg' ? 
          SvgPicture.asset(model.image) : Image.asset(model.image)
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          model.title,
          style: const TextStyle(
               fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          model.body,
          textAlign: TextAlign.center,
          style: const TextStyle(
               fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
