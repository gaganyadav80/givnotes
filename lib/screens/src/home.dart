import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:givnotes/controllers/controllers.dart';

import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TapTapClose(
      child: DefaultTabController(
        length: 4,
        child: Obx(
          () => Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar:
                CustomAppBar(index: PrefsController.to.homeSelectedIndex.value),
            body: IndexedStack(
              index: PrefsController.to.homeSelectedIndex.value,
              children: const <Widget>[
                NotesView(),
                TodoTimelineBloc(),
                TagsView(),
                SettingsPage(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              iconSize: 26.w,
              selectedFontSize: 13.w,
              unselectedFontSize: 13.w,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              currentIndex: PrefsController.to.homeSelectedIndex.value,
              onTap: (index) => PrefsController.to.setHomeIndex(index),
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(FluentIcons.home_24_regular),
                  activeIcon: Icon(FluentIcons.home_24_filled),
                  label: 'Notes',
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
                  icon: Icon(FluentIcons.settings_24_regular),
                  activeIcon: Icon(FluentIcons.settings_24_filled),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
