import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:givnotes/widgets/circular_loading.dart';
import 'package:velocity_x/velocity_x.dart';

import '../screens/src/minimal_login/components/constants.dart';

class BlueButton extends StatelessWidget {
  final Function onPressed;
  final String title;

  /// If [isLoading] is [true] then it will override both
  /// [child] and [title].
  final bool isLoading;

  /// If [child] is null then [title] will be used
  /// Otherwise, [child] will override [title]
  final Widget child;

  /// Default value is 60.
  final double height;

  const BlueButton({this.title, @required this.onPressed, this.isLoading = false, this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: kBorderRadius,
      color: Colors.transparent,
      elevation: 0.0,
      shadowColor: Theme.of(context).primaryColor.withOpacity(0.5),
      child: Container(
        height: height ?? 60.w,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            elevation: 0.0,
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
            padding: EdgeInsets.symmetric(vertical: 15.w),
            primary: Colors.lightBlue[900],
          ),
          child: Center(
            child: isLoading ? CircularLoading(color: Colors.white) : child ?? title.text.xl.light.white.make(),
          ),
        ),
      ),
    );
  }
}
