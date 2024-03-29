import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:givnotes/widgets/widgets.dart';

class GivnotesDialog extends StatelessWidget {
  const GivnotesDialog({
    Key? key,
    required this.title,
    this.message,
    this.showCancel = false,
    this.mainButtonText = "Okay",
    this.onTap,
    this.content,
  }) : super(key: key);

  final String title;
  final String? message;
  final String mainButtonText;
  final bool showCancel;
  final Function? onTap;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0.r)),
      child: Container(
        width: 300.w,
        padding: EdgeInsets.only(top: 20.0.w),
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
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            message!.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.fromLTRB(15.0.w, 8.0.w, 15.0.w, 15.0.w),
                    child: Text(
                      message!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0.w,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            content ?? const SizedBox.shrink(),
            const TilesDivider(),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap as void Function()? ?? () => Navigator.pop(context, true),
                child: Container(
                  // height: 30.0,
                  padding: EdgeInsets.symmetric(vertical: 18.0.w),
                  child: Center(
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0.w,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            showCancel ? const TilesDivider() : const SizedBox.shrink(),
            showCancel
                ? Material(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(12.0.r)),
                    ),
                    child: InkWell(
                      onTap: () => Navigator.pop(context, false),
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(12.0.r)),
                      child: Container(
                        padding: EdgeInsets.only(top: 18.w, bottom: 23.w),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0.w,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
