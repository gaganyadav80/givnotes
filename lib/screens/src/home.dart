import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hive/hive.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/database/database.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/widgets/custom_appbar.dart';

import 'todo_timeline/todo_home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    // GoogleSignIn.standard().signOut();
    // FirebaseAuth.instance.signOut();
    // Hive.deleteBoxFromDisk("givtodos");
    return TapTapClose(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            trailing: CupertinoIcons.search,
          ),
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return IndexedStack(
                index: state.index,
                children: <Widget>[
                  NotesView(), //? 0
                  // TodoHome(),
                  TodoTimelineBloc(), //? 1
                  TagsView(), //? 2
                  SettingsPage(), //? 3
                  // MyProfile(), //? 4
                  // AboutUs(), //? 5
                ],
              );
            },
          ),
          bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              return Container(
                height: 60,
                child: CupertinoTabBar(
                  backgroundColor: Colors.white,
                  activeColor: Colors.black,
                  currentIndex: state.index,
                  onTap: (index) => BlocProvider.of<HomeCubit>(context).updateIndex(index),
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(icon: Icon(state.index == 0 ? CupertinoIcons.book_fill : CupertinoIcons.book, size: 36)),
                    BottomNavigationBarItem(
                      icon: GFIconBadge(
                        counterChild: GFBadge(
                          color: state.index == 1 || Hive.box<TodoModel>('givtodos').length == 0 ? Colors.transparent : Colors.black,
                          text: state.index == 1 || Hive.box<TodoModel>('givtodos').length == 0 ? null : "${Hive.box<TodoModel>('givtodos').length}",
                        ),
                        child: Icon(state.index == 1 ? CupertinoIcons.layers_fill : CupertinoIcons.layers, size: 36),
                      ),
                    ),
                    BottomNavigationBarItem(icon: Icon(state.index == 2 ? CupertinoIcons.tag_fill : CupertinoIcons.tag)),
                    BottomNavigationBarItem(
                      icon: GFIconBadge(
                        child: Icon(CupertinoIcons.settings, size: 36),
                        counterChild: FirebaseAuth.instance.currentUser.emailVerified ? GFBadge(color: Colors.transparent) : GFBadge(text: "!"),
                      ),
                    ),
                  ],
                ),
              );
              // return SnakeNavigationBar.color(
              //   backgroundColor: Colors.white,
              //   selectedItemColor: Colors.black,
              //   unselectedItemColor: Colors.black45,
              //   snakeViewColor: Colors.black,
              //   currentIndex: state.index,
              //   snakeShape: SnakeShape.indicator,
              //   onTap: (index) => BlocProvider.of<HomeCubit>(context).updateIndex(index),
              //   items: <BottomNavigationBarItem>[
              //     BottomNavigationBarItem(icon: Icon(CupertinoIcons.book, size: 32), label: 'Home'),
              //     BottomNavigationBarItem(icon: Icon(CupertinoIcons.layers, size: 32)),
              //     BottomNavigationBarItem(
              //       icon: Transform.rotate(angle: 1.5708, child: Icon(Octicons.tag, size: 32)),
              //     ),
              //     BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings, size: 32)),
              //   ],
              // );
            },
          ),
        ),
      ),
    );
  }
}
