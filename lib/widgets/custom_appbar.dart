import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/screens/src/notes/widgets/notes_widgets.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(65.0);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  static const List<IconData> _appBarIcon = [
    CupertinoIcons.search,
    CupertinoIcons.calendar_today,
    null,
    null,
  ];

  static const List<String> _appBarTitle = [
    'Notes',
    'Todos',
    'Tags',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 10.h, 20.w, 5.h),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _appBarTitle[state.index],
                    style: TextStyle(
                      height: 1.2.w,
                      fontSize: 36.w,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.7.w,
                      color: const Color(0xff32343D),
                    ),
                  ),
                  Row(
                    children: [
                      state.index == 0
                          ? Material(
                              type: MaterialType.transparency,
                              child: Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: IconButton(
                                  splashRadius: 25.0,
                                  iconSize: 22.0.w,
                                  icon: Icon(CupertinoIcons.collections),
                                  onPressed: () => showCupertinoModalBottomSheet(
                                    expand: true,
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => NotesOptionModalSheet(),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      _appBarIcon[state.index] != null
                          ? Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                child: Icon(_appBarIcon[state.index], size: 28.w),
                                // splashRadius: 25.0,
                                key: widget.key,
                                onTap: state.index == 0
                                    ? () => Navigator.pushNamed(context, RouterName.searchRoute)
                                    : () async {
                                        await showDatePicker(
                                          context: context,
                                          initialDate: appBarDate,
                                          currentDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2025),
                                          builder: (context, child) {
                                            return Theme(
                                              data: ThemeData.dark(),
                                              child: child,
                                            );
                                          },
                                        ).then((value) {
                                          if (value != null) {
                                            todoTimelineState.setState(() {
                                              appBarDate = value;
                                            });
                                          }
                                        });
                                      },
                              ),
                            )
                          : SizedBox.shrink(),
                      state.index == 1
                          ? Padding(
                              padding: EdgeInsets.only(left: 20.0.w),
                              child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  child: Icon(CupertinoIcons.create),
                                  onTap: () => Navigator.pushNamed(context, RouterName.createTodoRoute,
                                      arguments: [false, null, null]),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
