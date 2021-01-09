import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/screens/src/settings.dart';
import 'package:givnotes/screens/src/tagsView.dart';
import 'package:givnotes/widgets/custom_appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return TapTapClose(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            icon: CupertinoIcons.search,
          ),
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return IndexedStack(
                index: state.index,
                children: <Widget>[
                  NotesView(), //? 0
                  TodoHome(), //? 1
                  TagsView(), //? 2
                  SettingsPage(), //? 3
                  // Profile(),
                  // AboutUs(),
                ],
              );
              // return _pageNavigation[state];
            },
          ),
          bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              return SnakeNavigationBar.color(
                backgroundColor: Colors.white,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.black45,
                snakeViewColor: Colors.black,
                currentIndex: state.index,
                // elevation: 15.0,
                snakeShape: SnakeShape.indicator,
                onTap: (index) =>
                    BlocProvider.of<HomeCubit>(context).updateIndex(index),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.book,
                      size: 32,
                    ),
                    // label: 'Notes',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      //maybe list_dash
                      CupertinoIcons.layers,
                      size: 32,
                    ),
                    // label: 'Seach',
                  ),
                  BottomNavigationBarItem(
                    icon: Transform.rotate(
                      angle: 1.5708,
                      child: Icon(
                        Octicons.tag,
                        size: 32,
                      ),
                    ),
                    // label: 'Tags',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.settings,
                      size: 32,
                    ),
                    // label: 'Settings',
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
