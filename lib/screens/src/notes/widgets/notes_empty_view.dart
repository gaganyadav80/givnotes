import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotesEmptyView extends StatelessWidget {
  const NotesEmptyView({Key key, @required this.isTrash}) : super(key: key);

  final bool isTrash;

  @override
  Widget build(BuildContext context) {
    return isTrash
        ? SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(
                    child: Text(
                      "You don't have any trash",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.w),
                  Center(
                    child: Text(
                      "Create 'em, trash 'em. See them",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 0.3.sh),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Image(
                      image: AssetImage('assets/img/trash.png'),
                      height: 180.w,
                      width: 180.w,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/img/lady-on-phone.png',
              width: 300.w,
              height: 250.h,
            ),
          );
  }
}
