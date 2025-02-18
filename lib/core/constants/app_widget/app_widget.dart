import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AppTextSpan extends StatelessWidget {
  final String? text1;
  final String? text2;
  final TapGestureRecognizer onTapped;
  const AppTextSpan(
      {this.text1, this.text2, required this.onTapped, super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(children: [
      TextSpan(text: text1, style: TextStyle(fontSize: 14)),
      TextSpan(
          text: text2,
          recognizer: onTapped,
          style: TextStyle(color: Colors.deepPurple))
    ]));
  }
}
