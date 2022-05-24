import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:givnotes/controllers/controllers.dart';
import 'package:givnotes/services/services.dart';

import 'package:givnotes/routes.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  // static const List<String> _appBarTitle = ['Todos', 'Tags', 'Settings'];

  final TodoDateController _todoController = Get.find<TodoDateController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: widget.index == 0
          ? const SizedBox.shrink()
          : AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              // title: _appBarTitle[widget.index - 1]
              //     .text
              //     .size(36.w)
              //     .extraBlack
              //     .color(const Color(0xff32343D))
              //     .make(),
              leading: SvgPicture.asset('assets/logo/givnotes_logo.svg'),
              actions: widget.index == 1
                  ? [
                      IconButton(
                        splashRadius: 25.0,
                        icon: Icon(
                          FluentIcons.calendar_ltr_24_regular,
                          size: 34.w,
                          color: Colors.black,
                        ),
                        key: widget.key,
                        onPressed: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: _todoController.date,
                            currentDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2025),
                            // builder: (context, child) {
                            //   return Theme(
                            //     data: ThemeData.light(),
                            //     child: child!,
                            //   );
                            // },
                          ).then((value) {
                            if (value != null) {
                              Future.delayed(const Duration(milliseconds: 300), () {
                                _todoController.appBarDate.value = value;
                              });
                            }
                          });
                        },
                      ),
                      IconButton(
                        splashRadius: 25.0,
                        icon: const Icon(
                          FluentIcons.task_list_square_add_24_regular,
                          size: 30,
                          color: Colors.black,
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, RouterName.createTodoRoute, arguments: [false, null, null]),
                      ),
                      HSpace(10.w),
                    ]
                  : null,
            ),
    );
  }
}
