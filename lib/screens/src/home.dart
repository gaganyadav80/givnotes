import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/screens/src/todo_timeline/todo_timeline.dart';
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
  final double _kIconSize = 26.w;

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
                selectedFontSize: 13.w,
                unselectedFontSize: 13.w,
                backgroundColor: Colors.white,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                currentIndex: state.index,
                onTap: (index) => BlocProvider.of<HomeCubit>(context).updateIndex(index),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.house),
                    activeIcon: Icon(CupertinoIcons.house_fill),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
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
                    icon: Icon(CupertinoIcons.settings),
                    activeIcon: Icon(CupertinoIcons.settings_solid),
                    label: 'Settings',
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
