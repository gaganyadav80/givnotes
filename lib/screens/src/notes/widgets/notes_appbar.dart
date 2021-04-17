import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/global/size_utils.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/routes.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';

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
          : SizedBox.shrink(),
    );
  }
}

class ModalSheetTabView extends StatefulWidget {
  ModalSheetTabView({Key key}) : super(key: key);

  @override
  _ModalSheetTabViewState createState() => _ModalSheetTabViewState();
}

class _ModalSheetTabViewState extends State<ModalSheetTabView> with SingleTickerProviderStateMixin {
  TabController tabController;
  var index = 0.obs;

  final List<String> sortName = ["Creation Date", "Modification date", "Alphabetical (A-Z)", "Alphabetical (Z-A)"];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      index.value = tabController.index;
      // index.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final HydratedPrefsCubit hydratedPrefsCubit = BlocProvider.of<HydratedPrefsCubit>(context);

    var def = hydratedPrefsCubit.state.sortBy == 'created'
        ? 0.obs
        : hydratedPrefsCubit.state.sortBy == 'modified'
            ? 1.obs
            : hydratedPrefsCubit.state.sortBy == 'a-z'
                ? 2.obs
                : 3.obs;

    return WillPopScope(
      onWillPop: () async {
        if (tabController.index != 0) {
          tabController.animateTo(0);
          return false;
        }

        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 56.0),
          child: Obx(
            () => AppBar(
              leading: index.value == 0
                  ? SizedBox.shrink()
                  : IconButton(
                      icon: Icon(CupertinoIcons.back),
                      color: Colors.grey,
                      onPressed: () {
                        tabController.animateTo(0);
                      },
                    ),
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: Text(
                'Notes Options',
                style: TextStyle(
                  fontSize: screenWidth * 0.04583756, //22,
                  fontWeight: FontWeight.w700,
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
          ),
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          controller: tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            NotesBottomSheet(
              tabController: tabController,
              prefsCubit: hydratedPrefsCubit,
              sortby: def,
            ),
            Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  TilesDivider(),
                  ListTile(
                    title: Text(
                      'Creation Date',
                    ),
                    // horizontalTitleGap: 0.0,
                    tileColor: Colors.white,
                    onTap: () {
                      PrefService.setString(sortName[def.value], 'Date Created');
                      hydratedPrefsCubit.updateSortBy('created');
                      def.value = 0;
                    },
                    trailing: def.value == 0 ? Icon(CupertinoIcons.checkmark, color: Color(0xFFDD4C4F)) : null,
                  ),
                  TilesDivider(),
                  ListTile(
                    title: Text(
                      'Modification Date',
                    ),
                    // horizontalTitleGap: 0.0,
                    tileColor: Colors.white,
                    onTap: () {
                      PrefService.setString(sortName[def.value], 'Date Modified');
                      hydratedPrefsCubit.updateSortBy('modified');
                      def.value = 1;
                    },
                    trailing: def.value == 1 ? Icon(CupertinoIcons.checkmark, color: Color(0xFFDD4C4F)) : null,
                  ),
                  TilesDivider(),
                  ListTile(
                    title: Text(
                      'Alphabetical (A-Z)',
                    ),
                    // horizontalTitleGap: 0.0,
                    tileColor: Colors.white,
                    onTap: () {
                      PrefService.setString(sortName[def.value], 'Alphabetical (A-Z)');
                      hydratedPrefsCubit.updateSortBy('a-z');
                      def.value = 2;
                    },
                    trailing: def.value == 2 ? Icon(CupertinoIcons.checkmark, color: Color(0xFFDD4C4F)) : null,
                  ),
                  TilesDivider(),
                  ListTile(
                    title: Text(
                      'Alphabetical (Z-A)',
                    ),
                    // horizontalTitleGap: 0.0,
                    tileColor: Colors.white,

                    onTap: () {
                      PrefService.setString(sortName[def.value], 'Alphabetical (Z-A)');
                      hydratedPrefsCubit.updateSortBy('z-a');
                      def.value = 3;
                    },
                    trailing: def.value == 3 ? Icon(CupertinoIcons.checkmark, color: Color(0xFFDD4C4F)) : null,
                  ),
                  TilesDivider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotesBottomSheet extends StatelessWidget {
  NotesBottomSheet({Key key, @required this.tabController, @required this.prefsCubit, @required this.sortby}) : super(key: key);

  final TabController tabController;
  final RxInt sortby;
  final HydratedPrefsCubit prefsCubit;

  final List<String> sortName = ["Creation Date", "Modification date", "Alphabetical (A-Z)", "Alphabetical (Z-A)"];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        // mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 10.0),
          TilesDivider(),
          PreferenceText(
            "Sort Notes",
            style: TextStyle(fontWeight: FontWeight.w600),
            titleGap: 0.0,
            leading: Icon(
              CupertinoIcons.square_arrow_right,
              color: Theme.of(context).textTheme.bodyText1.color,
            ),
            trailing: Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Obx(
                      () => Text(
                        sortName[sortby.value],
                        style: TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    CupertinoIcons.forward,
                    size: 21.0,
                    color: Color(0xFFDD4C4F),
                  ),
                ],
              ),
            ),
            onTap: () {
              tabController.animateTo(1);
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
            defaultVal: prefsCubit.state.compactTags,
            onEnable: () => prefsCubit.updateCompactTags(true),
            onDisable: () => prefsCubit.updateCompactTags(false),
          ),
          TilesDivider(),
          ListTile(
            tileColor: Colors.transparent,
            dense: true,
          ),
          TilesDivider(),
          PreferenceText(
            "Trash",
            style: TextStyle(fontWeight: FontWeight.w600),
            backgroundColor: Colors.white,
            leading: Icon(
              CupertinoIcons.delete,
              color: Theme.of(context).textTheme.bodyText1.color,
              size: 20.0,
            ),
            trailing: Icon(
              CupertinoIcons.forward,
              size: 21.0,
              color: Color(0xFFDD4C4F),
            ),
            titleGap: 0.0,
            onTap: () {
              BlocProvider.of<HomeCubit>(context).updateTrash(true);
              Navigator.pushNamed(context, RouterName.notesviewRoute);
            },
          ),
          TilesDivider(),
        ],
      ),
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
