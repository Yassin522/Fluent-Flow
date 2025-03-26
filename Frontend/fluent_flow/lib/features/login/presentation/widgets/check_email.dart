import 'package:flutter/material.dart';
import '../../../../core/widgets/fluent_button_widget.dart';

// ignore: must_be_immutable
class CheckEmail extends StatelessWidget {
  CheckEmail({
    Key? key,
    required this.text
  }) : super(key: key);

  String text;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          const Image(
            image: AssetImage('assets/images/4.png'),
            fit: BoxFit.fitWidth,
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: const TextStyle(
                fontSize: 16,
                
                fontWeight: FontWeight.w800),
          ),
          Expanded(child: Container()),
          ExpoButton(
            text: "Login",
            function: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
  }
}
