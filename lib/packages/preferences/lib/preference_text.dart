import 'package:flutter/material.dart';

class PreferenceText extends StatelessWidget {
  final String text;

  final TextStyle style;
  final Decoration decoration;

  final Widget leading;
  final Text subtitle;

  final Function onTap;

  final TextOverflow overflow;

  final double titleGap;

  final Color leadingColor;

  PreferenceText(
    this.text, {
    this.style,
    this.decoration,
    this.leading,
    this.subtitle,
    this.onTap,
    this.overflow = TextOverflow.ellipsis,
    this.titleGap,
    this.leadingColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: ListTile(
        horizontalTitleGap: titleGap,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: leadingColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              height: 30.0,
              width: 30.0,
              child: Center(child: leading),
            ),
          ],
        ),
        onTap: onTap,
        title: Text(
          text,
          style: style,
          overflow: overflow,
        ),
        subtitle: subtitle,
      ),
    );
  }
}
