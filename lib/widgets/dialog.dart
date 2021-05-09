import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GivnotesDialog extends StatelessWidget {
  const GivnotesDialog({
    Key key,
    @required this.title,
    this.message,
    this.showCancel = false,
    this.mainButtonText = "Okay",
    this.onTap,
    this.content,
  }) : super(key: key);

  final String title;
  final String message;
  final String mainButtonText;
  final bool showCancel;
  final Function onTap;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0.r)),
      child: Container(
        width: 350.w,
        // height: 180.0,
        padding: EdgeInsets.only(top: 15.0.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0.r),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0.w,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            message.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.fromLTRB(15.0.w, 8.0.h, 15.0.w, 15.0.h),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14.0.w,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            content ?? SizedBox.shrink(),
            showCancel
                ? Divider(
                    height: 0.0,
                    color: Colors.black54,
                    thickness: 1.0,
                  )
                : SizedBox.shrink(),
            showCancel
                ? Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context, false),
                      child: Container(
                        // height: 30.0,
                        padding: EdgeInsets.symmetric(vertical: 18.0.h),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0.w,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            Divider(
              height: 0.0,
              color: Colors.black54,
              thickness: 1.0,
            ),
            Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.0.r)),
              ),
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.0.r)),
                onTap: onTap == null ? () => Navigator.pop(context, true) : onTap,
                child: Container(
                  // height: 30.0,
                  padding: EdgeInsets.symmetric(vertical: 18.0.h),
                  child: Center(
                    child: Text(
                      mainButtonText,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0.w,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
