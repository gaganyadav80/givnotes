import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'constants.dart';

class GoogleButton extends StatelessWidget {
  final Function onPressed;
  final String title;
  GoogleButton({@required this.title, @required this.onPressed})
      : assert(onPressed != null),
        assert(title != null);
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: kBorderRadius,
      color: Colors.transparent,
      elevation: 0.0,
      shadowColor: Colors.grey[400].withOpacity(0.2),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          padding: EdgeInsets.symmetric(vertical: 15.w),
          // color: Theme.of(context).scaffoldBackgroundColor,
          primary: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: kBorderRadius,
            side: BorderSide(
              width: 1.0,
              color: Colors.grey[500].withOpacity(0.5),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/logo/google.svg',
              alignment: Alignment.center,
              fit: BoxFit.contain,
              height: 26.w,
              width: 26.w,
            ),
            SizedBox(width: 21.w),
            Text(
              title,
              style: Theme.of(context).textTheme.caption.copyWith(fontSize: 16.w),
            )
          ],
        ),
      ),
    );
  }
}
