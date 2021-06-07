import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/screens/src/trash_view.dart';
import 'package:givnotes/services/services.dart';
import 'package:givnotes/widgets/widgets.dart';

class NotesOptionModalSheet extends StatelessWidget {
  NotesOptionModalSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext rootContext) {
    final HydratedPrefsCubit prefsCubit = BlocProvider.of<HydratedPrefsCubit>(rootContext);
    final RxInt sortby = prefsCubit.state.sortby.obs;

    return Material(
      child: Navigator(
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => Builder(
            builder: (context) => CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text('Notes Option'),
                automaticallyImplyLeading: false,
                transitionBetweenRoutes: true,
                trailing: TextButton(
                  child: 'Done'.text.color(Colors.blue).bold.make(),
                  onPressed: () => Navigator.of(rootContext).pop(),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: ListView(
                  shrinkWrap: true,
                  controller: ModalScrollController.of(context),
                  children: [
                    SizedBox(height: 10.0.w),
                    TilesDivider(),
                    PreferenceText(
                      "Sort Notes",
                      style: TextStyle(fontWeight: FontWeight.w600),
                      titleGap: 0.0,
                      leading: Icon(
                        CupertinoIcons.square_arrow_right,
                        color: Colors.black,
                      ),
                      trailing: Container(
                        width: 200.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 5.0.w),
                              child: Obx(
                                () => VariableService().sortbyNames[sortby.value]
                                    .text
                                    .size(15.w)
                                    .light
                                    .color(CupertinoColors.systemGrey)
                                    .make(),
                              ),
                            ),
                            Icon(
                              CupertinoIcons.forward,
                              size: 21.0.w,
                              color: Color(0xFFDD4C4F),
                            ),
                          ],
                        ),
                      ),
                      onTap: () => Navigator.of(context).push(
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: SortByModalPage(rootContext: rootContext, sortby: sortby),
                        ),
                      ),
                    ),
                    TilesDivider(),
                    ListTile(tileColor: Colors.transparent, dense: true),
                    TilesDivider(),
                    SwitchPreference(
                      'Compact Tags',
                      'compact_tags',
                      titleColor: Colors.black,
                      titleGap: 0.0,
                      leading: Icon(
                        CupertinoIcons.bars,
                        color: Colors.black,
                      ),
                      desc: 'Enable compact tags in notes view',
                      defaultVal: prefsCubit.state.compactTags,
                      onEnable: () => prefsCubit.updateCompactTags(true),
                      onDisable: () => prefsCubit.updateCompactTags(false),
                    ),
                    TilesDivider(),
                    ListTile(tileColor: Colors.transparent, dense: true),
                    TilesDivider(),
                    PreferenceText(
                      "Trash",
                      style: TextStyle(fontWeight: FontWeight.w600),
                      backgroundColor: Colors.white,
                      leading: Icon(
                        CupertinoIcons.delete,
                        color: Colors.black,
                        size: 20.0.w,
                      ),
                      trailing: Icon(
                        CupertinoIcons.forward,
                        size: 21.0.w,
                        color: Color(0xFFDD4C4F),
                      ),
                      titleGap: 0.0,
                      onTap: () => Navigator.of(context).push(
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: TrashView(
                            modalController: ModalScrollController.of(context),
                            rootContext: rootContext,
                          ),
                        ),
                      ),
                    ),
                    TilesDivider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SortByModalPage extends StatelessWidget {
  const SortByModalPage({Key key, @required this.rootContext, @required this.sortby}) : super(key: key);

  final BuildContext rootContext;
  final RxInt sortby;

  @override
  Widget build(BuildContext context) {
    final HydratedPrefsCubit prefsCubit = BlocProvider.of<HydratedPrefsCubit>(rootContext);

    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Sort by'),
          transitionBetweenRoutes: true,
          trailing: TextButton(
            child: 'Done'.text.color(Colors.blue).bold.make(),
            onPressed: () => Navigator.of(rootContext).pop(),
          ),
        ),
        child: SafeArea(
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10.0.w),
                TilesDivider(),
                ListTile(
                  title: Text('Creation Date'),
                  tileColor: Colors.white,
                  onTap: () {
                    prefsCubit.updateSortBy(0);
                    sortby.value = 0;
                  },
                  trailing: sortby.value == 0 ? Icon(CupertinoIcons.checkmark, color: Color(0xFFDD4C4F)) : null,
                ),
                TilesDivider(),
                ListTile(
                  title: Text('Modification Date'),
                  tileColor: Colors.white,
                  onTap: () {
                    prefsCubit.updateSortBy(1);
                    sortby.value = 1;
                  },
                  trailing: sortby.value == 1 ? Icon(CupertinoIcons.checkmark, color: Color(0xFFDD4C4F)) : null,
                ),
                TilesDivider(),
                ListTile(
                  title: Text('Alphabetical (A-Z)'),
                  tileColor: Colors.white,
                  onTap: () {
                    prefsCubit.updateSortBy(2);
                    sortby.value = 2;
                  },
                  trailing: sortby.value == 2 ? Icon(CupertinoIcons.checkmark, color: Color(0xFFDD4C4F)) : null,
                ),
                TilesDivider(),
                ListTile(
                  title: Text('Alphabetical (Z-A)'),
                  tileColor: Colors.white,
                  onTap: () {
                    prefsCubit.updateSortBy(3);
                    sortby.value = 3;
                  },
                  trailing: sortby.value == 3 ? Icon(CupertinoIcons.checkmark, color: Color(0xFFDD4C4F)) : null,
                ),
                TilesDivider(),
              ],
            ),
          ),
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
