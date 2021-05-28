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

  BlueButton({this.title, @required this.onPressed, this.isLoading = false, this.child}) : assert(onPressed != null);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: kBorderRadius,
      color: Colors.transparent,
      elevation: 0.0,
      shadowColor: Theme.of(context).primaryColor.withOpacity(0.5),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          onPrimary: Theme.of(context).splashColor,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: kBorderRadius,
          ),
          padding: EdgeInsets.symmetric(vertical: 15.w),
          primary: Theme.of(context).primaryColor,
        ),
        child: Center(
            child:
                isLoading ? CircularLoading(color: Colors.white) : child ?? title.text.size(18.w).medium.white.make()),
      ),
    );
  }
}
