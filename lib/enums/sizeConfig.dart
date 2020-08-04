import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static double _screenWidth;
  static double _screenHeight;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static double textMultiplier;
  static double imageMultiplier;
  static double heightMultiplier;
  static double widthMultiplier;

  void init(BoxConstraints constraints) {
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;

    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight / 100;

    textMultiplier = _blockHeight;
    imageMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;
  }
}

// static bool isPortrait = true;
// static bool isMobilePortrait = true;
// give argv {Orientation orientation} also
// if (orientation == Orientation.portrait) {
//   _screenWidth = constraints.maxWidth;
//   _screenHeight = constraints.maxHeight;
//   isPortrait = true;
//   if (_screenWidth < 450) {
//     isMobilePortrait = true;
//   }
// } else {
//    _screenWidth = constraints.maxHeight;
//   _screenHeight = constraints.maxWidth;
//   isPortrait = false;
//   isMobilePortrait = false;
// }
