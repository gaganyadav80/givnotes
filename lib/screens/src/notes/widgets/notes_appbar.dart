import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/global/size_utils.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/routes.dart';
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
                        0: Text(
                          'Recent',
                          style: TextStyle(
                            color: _homeCubit.state.global ? Colors.black : Colors.white,
                            fontSize: screenWidth * 0.03553299492, //14,
                          ),
                        ),
                        1: Text(
                          'Global',
                          style: TextStyle(
                            color: _homeCubit.state.global ? Colors.white : Colors.black,
                            fontSize: screenWidth * 0.03553299492, //14,
                          ),
                        ),
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
                        // onPressed: () => showModalBottomSheet(
                        //   context: context,
                        //   builder: (context) {
                        //     return NotesModelSheet();
                        //   },
                        //   backgroundColor: Color(0xff171C26),
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        //   ),
                        // ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return NotesBottomSheet();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// class NotesModelSheet extends StatelessWidget {
//   NotesModelSheet({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final HydratedPrefsCubit hydratedPrefsCubit = BlocProvider.of<HydratedPrefsCubit>(context);
//     final Size screenSize = MediaQuery.of(context).size;
//     String def = hydratedPrefsCubit.state.sortBy == 'created'
//         ? 'Date created'
//         : hydratedPrefsCubit.state.sortBy == 'modified'
//             ? 'Date modified'
//             : hydratedPrefsCubit.state.sortBy == 'a-z'
//                 ? "Alphabetical (A-Z)"
//                 : "Alphabetical (Z-A)";

//     return Container(
//       // height: 275,
//       height: 0.401842105 * screenSize.height,
//       // color: Color(0xff171C26),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               // padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
//               padding: EdgeInsets.fromLTRB(0.050761421 * screenSize.width, 0.039473684 * screenSize.height, 0, 0),
//               child: Text(
//                 'Note Options',
//                 style: TextStyle(
//                   fontSize: screenWidth * 0.05583756, //22,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).textTheme.bodyText1.color,
//                 ),
//               ),
//             ),
//             // SizedBox(height: 10),
//             SizedBox(height: 0.013157895 * screenSize.height),
//             DropdownPreference(
//               'Sort notes',
//               'sort_notes',
//               titleColor: Colors.white,
//               titleGap: 0.0,
//               leading: Icon(CupertinoIcons.sort_down_circle, color: Colors.white),
//               defaultVal: def,
//               desc: "Sort your notes on one of the following filters.",
//               showDesc: false,
//               values: ['Date created', 'Date modified', 'Alphabetical (A-Z)', 'Alphabetical (Z-A)'],
//               onChange: ((String value) {
//                 if (value == 'Date created')
//                   hydratedPrefsCubit.updateSortBy('created');
//                 else if (value == 'Date modified')
//                   hydratedPrefsCubit.updateSortBy('modified');
//                 else if (value == 'Alphabetical (A-Z)')
//                   hydratedPrefsCubit.updateSortBy('a-z');
//                 else
//                   hydratedPrefsCubit.updateSortBy('z-a');
//               }),
//             ),
//             SwitchPreference(
//               'Compact Tags',
//               'compact_tags',
//               titleColor: Colors.white,
//               titleGap: 0.0,
//               leading: Icon(CupertinoIcons.bars, color: Colors.white),
//               desc: 'Enable compact tags in notes view',
//               defaultVal: hydratedPrefsCubit.state.compactTags,
//               onEnable: () => hydratedPrefsCubit.updateCompactTags(true),
//               onDisable: () => hydratedPrefsCubit.updateCompactTags(false),
//             ),
//             PreferenceText(
//               "Trash",
//               style: TextStyle(color: Colors.white),
//               leading: Icon(CupertinoIcons.delete, color: Colors.white, size: 20.0),
//               trailing: Icon(CupertinoIcons.forward, size: 21.0, color: Colors.white60),
//               titleGap: 0.0,
//               onTap: () {
//                 BlocProvider.of<HomeCubit>(context).updateTrash(true);
//                 Navigator.pop(context);
//                 Navigator.push(context, NotesView().materialRoute());
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class NotesBottomSheet extends StatelessWidget {
  NotesBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HydratedPrefsCubit hydratedPrefsCubit = BlocProvider.of<HydratedPrefsCubit>(context);
    // final Size screenSize = MediaQuery.of(context).size;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? Colors.black : Colors.grey[300];
    // Color tileColor = isDark ? Colors.black.withOpacity(0.7) : Colors.white;
    String def = hydratedPrefsCubit.state.sortBy == 'created'
        ? 'Date created'
        : hydratedPrefsCubit.state.sortBy == 'modified'
            ? 'Date modified'
            : hydratedPrefsCubit.state.sortBy == 'a-z'
                ? "Alphabetical (A-Z)"
                : "Alphabetical (Z-A)";

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          'Notes Options',
          style: TextStyle(
            fontSize: screenWidth * 0.04583756, //22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyText1.color,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Container(
            //   height: 0.013157895 * screenSize.height,
            //   width: MediaQuery.of(context).size.width,
            //   color: Colors.transparent,
            // ),
            TilesDivider(),

            ListTile(
              tileColor: Colors.white,
              leading: Icon(
                CupertinoIcons.sort_down_circle,
                color: Theme.of(context).textTheme.bodyText1.color,
              ),
              title: Text(
                'Sort Notes',
                style: tileTextStyle(context),
              ),
              trailing: Text(
                def,
                style: tileTextStyle(context),
              ),
              horizontalTitleGap: 0.0,
              dense: true,
            ),
            TilesDivider(),

            ListTile(
              title: Text(
                'Date Created',
                style: tileTextStyle(context),
              ),
              // horizontalTitleGap: 0.0,
              tileColor: Theme.of(context).canvasColor,
              onTap: () {
                PrefService.setString(def, 'Date Created');
                hydratedPrefsCubit.updateSortBy('created');
                Navigator.of(context).pop();
              },
            ),
            TilesDivider(),
            ListTile(
              title: Text(
                'Date Modified',
                style: tileTextStyle(context),
              ),
              // horizontalTitleGap: 0.0,
              tileColor: Theme.of(context).canvasColor,
              onTap: () {
                PrefService.setString(def, 'Date Modified');
                hydratedPrefsCubit.updateSortBy('modified');
                Navigator.of(context).pop();
              },
            ),
            TilesDivider(),
            ListTile(
              title: Text(
                'Alphabetical (A-Z)',
                style: tileTextStyle(context),
              ),
              // horizontalTitleGap: 0.0,
              tileColor: Theme.of(context).canvasColor,
              onTap: () {
                PrefService.setString(def, 'Alphabetical (A-Z)');
                hydratedPrefsCubit.updateSortBy('a-z');
                Navigator.of(context).pop();
              },
            ),
            TilesDivider(),

            ListTile(
              title: Text(
                'Alphabetical (Z-A)',
                style: tileTextStyle(context),
              ),
              // horizontalTitleGap: 0.0,
              tileColor: Theme.of(context).canvasColor,

              onTap: () {
                PrefService.setString(def, 'Alphabetical (Z-A)');
                hydratedPrefsCubit.updateSortBy('z-a');
                Navigator.of(context).pop();
              },
            ),
            TilesDivider(),
            ListTile(
              tileColor: Colors.transparent,
              dense: true,
            ),
            TilesDivider(),

            SwitchPreference(
              'Compact Tags',
              'compact_tags',
              titleColor: Theme.of(context).textTheme.bodyText1.color,
              // tileColor: Theme.of(context).canvasColor,
              titleGap: 0.0,
              leading: Icon(
                CupertinoIcons.bars,
                color: Theme.of(context).textTheme.bodyText1.color,
              ),
              desc: 'Enable compact tags in notes view',
              defaultVal: hydratedPrefsCubit.state.compactTags,
              onEnable: () => hydratedPrefsCubit.updateCompactTags(true),
              onDisable: () => hydratedPrefsCubit.updateCompactTags(false),
            ),
            TilesDivider(),

            ListTile(
              tileColor: Colors.transparent,
              dense: true,
            ),
            TilesDivider(),

            PreferenceText(
              "Trash",
              style: tileTextStyle(context),
              backgroundColor: Colors.white,
              leading: Icon(
                CupertinoIcons.delete,
                color: Theme.of(context).textTheme.bodyText1.color,
                size: 20.0,
              ),
              trailing: Icon(
                CupertinoIcons.forward,
                size: 21.0,
                color: Theme.of(context).textTheme.bodyText1.color,
              ),
              titleGap: 0.0,
              onTap: () {
                BlocProvider.of<HomeCubit>(context).updateTrash(true);
                Navigator.pop(context);
                Navigator.pushNamed(context, RouterName.notesviewRoute);
              },
            ),
            TilesDivider(),
          ],
        ),
      ),
    );
  }

  TextStyle tileTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).textTheme.bodyText1.color,
    );
  }
}

class TilesDivider extends StatelessWidget {
  const TilesDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0.0,
      thickness: 1.0,
    );
  }
}
