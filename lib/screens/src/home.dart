import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:getwidget/getwidget.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/global/variables.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/screens/src/todo_timeline/todo_timeline.dart';
import 'package:givnotes/services/services.dart';
import 'package:givnotes/widgets/widgets.dart';

import 'todo_timeline/todo_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double _kIconSize = 26.0.w;

  @override
  Widget build(BuildContext context) {
    return TapTapClose(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(),
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return IndexedStack(
                index: state.index,
                children: <Widget>[
                  NotesView(),
                  TodoTimelineBloc(),
                  TagsView(),
                  SettingsPage(),
                ],
              );
            },
          ),
          bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              return BottomNavigationBar(
                iconSize: _kIconSize,
                selectedFontSize: 13.0.w,
                unselectedFontSize: 13.0.w,
                backgroundColor: Colors.white,
                // selectedItemColor: Color(0xff0366d6),
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                elevation: 12.0,
                currentIndex: state.index,
                onTap: (index) => BlocProvider.of<HomeCubit>(context).updateIndex(index),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.house),
                    activeIcon: Icon(CupertinoIcons.house_fill),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    // icon: GFIconBadge(
                    //   counterChild: BlocBuilder<TodosBloc, TodosState>(
                    //     builder: (context, todostate) {
                    //       if (todostate is TodosLoaded) {
                    //         return GFBadge(
                    //           color: Colors.black,
                    //           text: todostate.todos.length > 0 ? "${todostate.todos.length}" : null,
                    //         );
                    //       } else {
                    //         return null;
                    //       }
                    //     },
                    //   ),
                    //   child: Icon(CupertinoIcons.layers),
                    // ),
                    icon: Icon(CupertinoIcons.layers),
                    activeIcon: Icon(CupertinoIcons.layers_fill),
                    label: 'Todo',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.grid),
                    activeIcon: Icon(CupertinoIcons.grid),
                    label: 'Tags',
                  ),
                  BottomNavigationBarItem(
                    icon: GFIconBadge(
                      child: Icon(CupertinoIcons.settings),
                      counterChild: FirebaseAuth.instance.currentUser == null
                          ? GFBadge(color: Colors.transparent)
                          : FirebaseAuth.instance.currentUser.emailVerified
                              ? GFBadge(color: Colors.transparent)
                              : GFBadge(text: "!"),
                    ),
                    label: 'Settings',
                  ),
                ],
              );
            },
          ),
          floatingActionButton: BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              return state.trash == false && state.index == 0
                  ? Container(
                      height: 65.0,
                      width: 65.0,
                      decoration: BoxDecoration(
                        color: Color(0xFFDD4C4F),
                        shape: BoxShape.circle,
                      ),
                      child: FloatingActionButton(
                        heroTag: 'fab',
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: Icon(Typicons.doc_add, color: Colors.white).rotate180(),
                        ),
                        //TODO bear app original
                        // DC4C4F
                        backgroundColor: Color(0xFFDD4C4F),
                        onPressed: () async {
                          await HandlePermission().requestPermission().then((value) async {
                            if (value) {
                              BlocProvider.of<NoteAndSearchCubit>(context).updateIsEditing(true);
                              BlocProvider.of<NoteAndSearchCubit>(context).updateNoteMode(NoteMode.Adding);
                              Navigator.pushNamed(
                                context,
                                RouterName.editorRoute,
                                arguments: [NoteMode.Adding, null],
                              );
                            } else {
                              if (isPermanentDisabled) {
                                HandlePermission().permanentDisabled(context);
                              }
                            }
                          });
                        },
                      ),
                    )
                  : SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
