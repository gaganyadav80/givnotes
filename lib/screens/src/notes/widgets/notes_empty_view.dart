import 'package:flutter/material.dart';
import 'package:givnotes/global/size_utils.dart';

class NotesEmptyView extends StatelessWidget {
  const NotesEmptyView({Key key, @required this.isTrash}) : super(key: key);

  final bool isTrash;

  @override
  Widget build(BuildContext context) {
    final hm = 7.6;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    // final wm = 3.93;
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
                        fontSize: 2.0 * hm,
                      ),
                    ),
                  ),
                  // SizedBox(height: 0.5 * hm),
                  SizedBox(height: 0.005 * screenSize.height),
                  Center(
                    child: Text(
                      "Create 'em, trash 'em. See them",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 1.5 * hm,
                      ),
                    ),
                  ),
                  // SizedBox(height: 30 * hm),
                  SizedBox(height: 0.3 * screenSize.height),
                  Padding(
                    // padding: EdgeInsets.only(bottom: hm),
                    padding: EdgeInsets.only(bottom: 0.01 * screenSize.height),
                    child: Image(
                      image: AssetImage('assets/img/trash.png'),
                      // height: 25 * hm,
                      // width: 45 * wm,
                      height: 0.25 * screenSize.height,
                      width: 0.45 * screenSize.width,
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
              width: 0.75 * screenSize.width,
              height: 0.336973684 * screenSize.height,
            ),
          );
  }
}
