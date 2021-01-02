import 'dart:math';

import 'package:flutter/material.dart';

class ConcentricClipper extends CustomClipper<Path> {
  final double radius;
  final double limit = 0.5;
  final double verticalPosition;
  final double progress;
  final double growFactor;
  final bool reverse;
  //custom parameters
  final double dy;
  final double dx;

  ConcentricClipper({
    this.progress = 0.0,
    this.verticalPosition = 0.85,
    this.radius = 30.0,
    this.growFactor = 30.0,
    this.reverse = false,
    this.dy = 0,
    this.dx = 0,
  });

  double y;

  @override
  Path getClip(Size size) {
    final path = Path();
    Rect shape;
    path.fillType = PathFillType.evenOdd;
    if (progress <= limit) {
      shape = _createGrowingShape(path, size);
    } else {
      shape = _createShrinkingShape(path, size);
    }
    path.addArc(shape, 0, 90);
    // path.addRect(rect);
    return path;
  }

  @override
  bool shouldReclip(ConcentricClipper oldClipper) {
    return progress != oldClipper.progress;
  }

  Rect _createGrowingShape(Path path, Size size) {
    double _progress = progress * growFactor;
    double _limit = limit * growFactor;
    double r = radius + pow(2, _progress);
    double delta = (1 - _progress / _limit) * radius;
    //custom added dx at end
    double x = (size.width / 2) + r - delta + dx;
    //custom condition (stock only if(dy==0))
    if (dy == 0)
      y = (size.height * verticalPosition) + radius;
    else
      y = dy;

    if (reverse) {
      x *= -1;
    }
    return Rect.fromCircle(center: Offset(x, y), radius: r);
  }

  Rect _createShrinkingShape(Path path, Size size) {
    double _progress = (progress - limit) * growFactor;
    double _limit = limit * growFactor;
    double r = radius + pow(2, _limit - _progress);
    double delta = _progress / _limit * radius;
    //custom added dx at end
    double x = size.width / 2 - r + delta + dx;
    //custom condition (stock only if(dy==0))
    if (dy == 0)
      y = (size.height * verticalPosition) + radius;
    else
      y = dy;

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    if (reverse) {
      x *= -1;
    }

    return Rect.fromCircle(center: Offset(x, y), radius: r);
  }
}
