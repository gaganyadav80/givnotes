import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/widgets/custom_appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    // GoogleSignIn.standard().signOut();
    // FirebaseAuth.instance.signOut();
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
                  TodoTimeline(), //? 1
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
                    BottomNavigationBarItem(
                      icon: Icon(state.index == 0 ? CupertinoIcons.book_fill : CupertinoIcons.book, size: 36),
                      // label: 'Notes',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(state.index == 1 ? CupertinoIcons.layers_fill : CupertinoIcons.layers, size: 36),
                      // label: 'Todos',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(state.index == 2 ? CupertinoIcons.tag_fill : CupertinoIcons.tag), //size: 27
                      // label: 'Tags',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(state.index == 3 ? CupertinoIcons.settings_solid : CupertinoIcons.settings, size: 36),
                      // label: 'Settings',
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
