import 'package:flutter/material.dart';

class CircleInputButtonConfig {
  // final double fontSize;
  /// default `MediaQuery.of(context).size.width * 0.095`
  final TextStyle textStyle;
  final Color backgroundColor;
  final double backgroundOpacity;
  final ShapeBorder shape;

  const CircleInputButtonConfig({
    this.textStyle,
    this.backgroundColor = const Color(0xFF757575),
    this.backgroundOpacity = 0.4,
    this.shape,
  });
}

class CircleInputButton extends StatelessWidget {
  final CircleInputButtonConfig config;

  final String text;
  final Sink<String> enteredSink;

  CircleInputButton({
    @required this.text,
    @required this.enteredSink,
    this.config = const CircleInputButtonConfig(),
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = config.textStyle ??
        TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.085,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        );

    return ElevatedButton(
      child: Text(
        text,
        style: textStyle,
      ),
      onPressed: () {
        enteredSink.add(text);
      },
      style: ElevatedButton.styleFrom(
        shape: config.shape ??
            CircleBorder(
              side: BorderSide(
                color: config.backgroundColor,
                width: 1.0,
                style: BorderStyle.solid,
              ),
            ),
        // primary: config.backgroundColor.withOpacity(config.backgroundOpacity),
        primary: Colors.transparent,
        shadowColor: config.backgroundColor.withOpacity(config.backgroundOpacity),
        elevation: 0,
      ),
    );
  }
}
