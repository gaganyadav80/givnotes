import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/routes.dart';
import 'package:givnotes/screens/screens.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  static const List<String> _appBarTitle = ['Todos', 'Tags', 'Settings'];

  final TodoDateController _dateController = Get.find<TodoDateController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: widget.index == 0
          ? const SizedBox.shrink()
          : AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: _appBarTitle[widget.index - 1]
                  .text
                  .heightRelaxed
                  .size(36.w)
                  .semiBold
                  .color(const Color(0xff32343D))
                  .make(),
              // title: Text(
              //   _appBarTitle[widget.index - 1],
              //   style: TextStyle(
              //     height: 1.2.w,
              //     fontSize: 36.w,
              //     fontWeight: FontWeight.w600,
              //     letterSpacing: -0.7.w,
              //     color: const Color(0xff32343D),
              //   ),
              // ),
              actions: widget.index == 1
                  ? [
                      InkWell(
                        child: Icon(CupertinoIcons.calendar_today,
                            size: 28.w, color: Colors.black),
                        // splashRadius: 25.0,
                        key: widget.key,
                        onTap: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: _dateController.date,
                            currentDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2025),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.dark(),
                                child: child!,
                              );
                            },
                          ).then((value) {
                            if (value != null) {
                              Future.delayed(const Duration(milliseconds: 300),
                                  () {
                                _dateController.appBarDate.value = value;
                              });
                            }
                          });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0.w),
                        child: InkWell(
                          child: const Icon(CupertinoIcons.create,
                              color: Colors.black),
                          onTap: () => Navigator.pushNamed(
                              context, RouterName.createTodoRoute,
                              arguments: [false, null, null]),
                        ),
                      ),
                      SizedBox(width: 20.w),
                    ]
                  : null,
            ),
    );
  }
}
