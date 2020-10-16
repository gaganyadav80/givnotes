import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class SpeedDialController extends ChangeNotifier {
  SpeedDialController();

  AnimationController _speedAnimationController;

  setAnimator(AnimationController controller) {
    _speedAnimationController = controller;
  }

  unfold() {
    if (this._speedAnimationController.isDismissed) {
      this._speedAnimationController.forward();
    } else {
      this._speedAnimationController.reverse();
    }
  }
}
