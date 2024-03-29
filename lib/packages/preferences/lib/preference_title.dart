import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class PreferenceTitle extends StatelessWidget {
  final String title;
  final TextStyle? style;

  const PreferenceTitle(this.title, {Key? key, this.style}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfff8f8f8),
      padding: const EdgeInsets.only(left: 15.0, bottom: 5.0, top: 16.0),
      child: title.text
          .size(14.0)
          .letterSpacing(1.0)
          .fontWeight(FontWeight.w500)
          .coolGray400
          .make(),
    );
  }
}
