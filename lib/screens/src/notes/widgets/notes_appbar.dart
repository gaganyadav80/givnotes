import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:velocity_x/velocity_x.dart';

class NotesAppBar extends StatelessWidget with PreferredSizeWidget {
  NotesAppBar(this.tabController);
  final TabController tabController;

  @override
  Size get preferredSize => Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final HomeCubit _homeCubit = BlocProvider.of<HomeCubit>(context);

    return SafeArea(
      child: _homeCubit.state.trash
          ? AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: "Trash".text.size(24.0).black.bold.make(),
              leading: InkWell(
                onTap: () async {
                  _homeCubit.updateTrash(false);
                  Navigator.pop(context);
                },
                child: Icon(CupertinoIcons.arrow_left, color: Colors.black),
              ),
            )
          : Container(
              color: Colors.white,
              width: screenSize.width,
              // margin: const EdgeInsets.only(left: 10.0),
              margin: EdgeInsets.only(left: 0.025380711 * screenSize.width),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 250.0,
                    child: CupertinoSlidingSegmentedControl(
                      thumbColor: Colors.black,
                      groupValue: _homeCubit.state.global ? 1 : 0,
                      onValueChanged: (int value) {
                        if (value == 0)
                          _homeCubit.updateGlobal(false);
                        else
                          _homeCubit.updateGlobal(true);
                      },
                      children: {
                        0: Text('Recent', style: TextStyle(color: _homeCubit.state.global ? Colors.black : Colors.white)),
                        1: Text('Global', style: TextStyle(color: _homeCubit.state.global ? Colors.white : Colors.black)),
                      },
                      // physics: NeverScrollableScrollPhysics(),
                      // isScrollable: true,
                      // indicatorSize: TabBarIndicatorSize.tab,
                      // labelPadding: const EdgeInsets.symmetric(horizontal: 15),
                      // labelColor: Colors.black,
                      // unselectedLabelColor: Colors.grey,
                      // labelStyle: TextStyle(
                      //   fontSize: 16,
                      //   fontWeight: FontWeight.w700,
                      // ),
                      // unselectedLabelStyle: TextStyle(
                      //   fontSize: 14,
                      //   fontWeight: FontWeight.w600,
                      // ),
                      // tabs: <Tab>[
                      //   const Tab(text: "Recent"),
                      //   // const Tab(text: "Trash"),
                      //   const Tab(text: "Global (Upcoming)"),
                      // ],
                      // controller: tabController,
                      // onTap: (int value) {
                      //   if (value == 0) {
                      //     BlocProvider.of<HomeCubit>(context).updateGlobal(false);
                      //     BlocProvider.of<HomeCubit>(context).updateTrash(false);
                      //     // } else if (value == 1) {
                      //     //   BlocProvider.of<HomeCubit>(context).updateGlobal(false);
                      //     //   BlocProvider.of<HomeCubit>(context).updateTrash(true);
                      //   } else
                      //     BlocProvider.of<HomeCubit>(context).updateGlobal(true);
                      // },
                    ),
                  ),
                  Material(
                    type: MaterialType.transparency,
                    child: Padding(
                      // padding: const EdgeInsets.only(right: 8.0),
                      padding: EdgeInsets.only(right: 0.020304569 * screenSize.width),
                      child: IconButton(
                        splashRadius: 25.0,
                        iconSize: 18.0,
                        icon: Icon(Icons.view_agenda_outlined),
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return NotesModelSheet();
                          },
                          backgroundColor: Color(0xff171C26),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class NotesModelSheet extends StatelessWidget {
  NotesModelSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HydratedPrefsCubit hydratedPrefsCubit = BlocProvider.of<HydratedPrefsCubit>(context);
    final Size screenSize = MediaQuery.of(context).size;
    String def = hydratedPrefsCubit.state.sortBy == 'created'
        ? 'Date created'
        : hydratedPrefsCubit.state.sortBy == 'modified'
            ? 'Date modified'
            : hydratedPrefsCubit.state.sortBy == 'a-z'
                ? "Alphabetical (A-Z)"
                : "Alphabetical (Z-A)";

    return Container(
      // height: 275,
      height: 0.361842105 * screenSize.height,
      // color: Color(0xff171C26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            // padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
            padding: EdgeInsets.fromLTRB(0.050761421 * screenSize.width, 0.039473684 * screenSize.height, 0, 0),
            child: Text(
              'Note Options',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // SizedBox(height: 10),
          SizedBox(height: 0.013157895 * screenSize.height),
          DropdownPreference(
            'Sort notes',
            'sort_notes',
            titleColor: Colors.white,
            titleGap: 0.0,
            leading: Icon(CupertinoIcons.sort_down_circle, color: Colors.white),
            defaultVal: def,
            desc: "Sort your notes on one of the following filters.",
            showDesc: false,
            values: ['Date created', 'Date modified', 'Alphabetical (A-Z)', 'Alphabetical (Z-A)'],
            onChange: ((String value) {
              if (value == 'Date created')
                hydratedPrefsCubit.updateSortBy('created');
              else if (value == 'Date modified')
                hydratedPrefsCubit.updateSortBy('modified');
              else if (value == 'Alphabetical (A-Z)')
                hydratedPrefsCubit.updateSortBy('a-z');
              else
                hydratedPrefsCubit.updateSortBy('z-a');
            }),
          ),
          SwitchPreference(
            'Compact Tags',
            'compact_tags',
            titleColor: Colors.white,
            titleGap: 0,
            leading: Icon(CupertinoIcons.bars, color: Colors.white),
            desc: 'Enable compact tags in notes view',
            defaultVal: hydratedPrefsCubit.state.compactTags,
            onEnable: () => hydratedPrefsCubit.updateCompactTags(true),
            onDisable: () => hydratedPrefsCubit.updateCompactTags(false),
          ),
          ListTile(
            leading: Icon(CupertinoIcons.trash, color: Colors.white, size: 20.0),
            horizontalTitleGap: 0,
            title: Text("Trash", style: TextStyle(color: Colors.white)),
            trailing: Icon(CupertinoIcons.forward, size: 21.0, color: Colors.white60),
            onTap: () {
              BlocProvider.of<HomeCubit>(context).updateTrash(true);
              Navigator.pop(context);
              Navigator.push(context, NotesView().materialRoute());
            },
          ),
        ],
      ),
    );
  }
}
