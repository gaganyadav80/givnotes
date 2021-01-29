import 'package:flutter/material.dart';

class PreferenceTitle extends StatelessWidget {
  final String title;
  final double leftPadding;
  final TextStyle style;
  final double topPadding;

  PreferenceTitle(this.title, {this.leftPadding = 10.0, this.style, this.topPadding = 20.0});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding, bottom: 0.0, top: topPadding),
      child: Text(
        title,
        style: style ??
            TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
      ),
    );
  }
}
