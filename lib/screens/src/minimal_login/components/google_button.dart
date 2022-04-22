import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givnotes/services/services.dart';

import 'constants.dart';

class GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  const GoogleButton({Key? key, required this.title, required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15.w),
        // color: Theme.of(context).scaffoldBackgroundColor,
        // primary: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: kBorderRadius,
          side: kInputBorderStyle.borderSide,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/logo/google.svg',
            alignment: Alignment.center,
            // fit: BoxFit.contain,
            height: 26.w,
            width: 26.w,
          ),
          HSpace(20.w),
          Text(title, style: Theme.of(context).textTheme.button!)
        ],
      ),
    );
  }
}
