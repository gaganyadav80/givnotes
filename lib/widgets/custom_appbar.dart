import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/global/size_utils.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/screens/src/notes/widgets/notes_widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
                      state.index == 0
                          ? Material(
                              type: MaterialType.transparency,
                              child: Padding(
                                // padding: const EdgeInsets.only(right: 8.0),
                                padding: EdgeInsets.only(right: 0.020304569 * screenSize.width),
                                child: IconButton(
                                  splashRadius: 25.0,
                                  iconSize: 22.0,
                                  icon: Icon(CupertinoIcons.collections),
                                  onPressed: () => showCupertinoModalBottomSheet(
                                    context: context,
                                    closeProgressThreshold: 0.5,
                                    builder: (context) {
                                      return ModalSheetTabView();
                                    },
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      _appBarIcon[state.index] != null
                          ? Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                child: Icon(_appBarIcon[state.index], size: 28),
                                // splashRadius: 25.0,
                                key: key,
                                onTap: state.index == 0
                                    ? () => Navigator.pushNamed(context, RouterName.searchRoute)
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
                                  child: Icon(CupertinoIcons.pencil_ellipsis_rectangle, size: 22.0),
                                  // splashRadius: 25.0,
                                  onTap: () => Navigator.pushNamed(context, RouterName.createTodoRoute, arguments: [false, null, null]),
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
