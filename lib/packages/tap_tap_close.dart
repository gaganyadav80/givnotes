import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'package:givnotes/packages/packages.dart';

class TapTapClose extends StatefulWidget {
  final Widget child;
  final String message;
  final int durationSeconds;

  const TapTapClose({
    Key key,
    @required this.child,
    this.message = "Press BACK again",
    this.durationSeconds = 2,
  }) : super(key: key);

  @override
  _TapTapCloseState createState() => _TapTapCloseState();
}

class _TapTapCloseState extends State<TapTapClose> {
  DateTime currentBackPressTime;

  bool get _isAndroid => Theme.of(context).platform == TargetPlatform.android;

  @override
  Widget build(BuildContext context) {
    if (_isAndroid) {
      return WillPopScope(
        onWillPop: () async {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
            currentBackPressTime = now;

            Toast.show(
              widget.message,
              context,
              duration: 2,
              gravity: Toast.BOTTOM,
            );
            return false;
          }

          Hive.close();
          if (_isAndroid) SystemNavigator.pop();
          return true;
        },
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }
}
