import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/screens/src/todo_timeline/create_todo.dart';
import 'package:givnotes/screens/src/todo_timeline/create_todo_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final IconData trailing;

  const CustomAppBar({Key key, this.trailing}) : super(key: key);
  @override
  Size get preferredSize => Size.fromHeight(65.0);

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
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 5.0),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _appBarTitle[state.index],
                    style: TextStyle(
                      height: 1.2,
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.7,
                      color: const Color(0xff32343D),
                    ),
                  ),
                  Row(
                    children: [
                      _appBarIcon[state.index] != null
                          ? Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                child: Icon(_appBarIcon[state.index], size: 28),
                                // splashRadius: 25.0,
                                key: key,
                                onTap: state.index == 0
                                    ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => SearchPage()),
                                          // ConcentricPageRoute(
                                          //   builder: (context) => SearchPage(),
                                          //   radius: -1,
                                          //   dy: 60,
                                          //   dx: 170,
                                          // ),
                                        );
                                      }
                                    : () async {
                                        await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2025),
                                          builder: (context, child) {
                                            return Theme(
                                              data: ThemeData.dark(),
                                              child: child,
                                            );
                                          },
                                        );
                                      },
                              ),
                            )
                          : SizedBox.shrink(),
                      state.index == 1
                          ? Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  child: Icon(CupertinoIcons.pencil_ellipsis_rectangle, size: 28.0),
                                  // splashRadius: 25.0,
                                  onTap: () => Navigator.push(context, CreateTodoBloc().materialRoute()),
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
          actions: [
            state.index == 0
                ? IconButton(
                    icon: Icon(trailing, size: 28),
                    splashColor: Colors.grey[300],
                    splashRadius: 25.0,
                    key: key,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage()),
                        // ConcentricPageRoute(
                        //   builder: (context) => SearchPage(),
                        //   radius: -1,
                        //   dy: 60,
                        //   dx: 170,
                        // ),
                      );
                    },
                  )
                : SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
