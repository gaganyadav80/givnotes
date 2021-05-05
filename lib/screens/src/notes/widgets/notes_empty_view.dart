import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

class NotesEmptyView extends StatelessWidget {
  const NotesEmptyView({Key key, @required this.isTrash}) : super(key: key);

  final bool isTrash;

  @override
  Widget build(BuildContext context) {
    return isTrash
        ? SafeArea(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(
                    child: Text(
                      "You don't have any trash",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.w,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Create 'em, trash 'em. See them",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 15.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 150.h),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Image(
                      image: AssetImage('assets/giv_img/empty_trash_light.png'),
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
              'assets/giv_img/empty_notes_light.png',
              width: 400.w,
            ),
          );
  }
}
