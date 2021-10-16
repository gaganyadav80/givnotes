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
  final Widget trailing;
  final Color backgroundColor;

  const PreferenceText(
    this.text, {
    Key key,
    this.style,
    this.decoration,
    this.leading,
    this.subtitle,
    this.onTap,
    this.overflow = TextOverflow.ellipsis,
    this.titleGap,
    this.leadingColor,
    this.trailing,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        horizontalTitleGap: titleGap,
        tileColor: backgroundColor,
        leading: leading == null
            ? leading
            : Container(
                decoration: BoxDecoration(
                  color: leadingColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                height: 30.0,
                width: 30.0,
                child: Center(child: leading),
              ),
        onTap: onTap,
        title: Text(
          text,
          style: style,
          overflow: overflow,
        ),
        subtitle: subtitle,
        trailing: trailing,
      ),
    );
  }
}
