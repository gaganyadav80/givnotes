import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/widgets/floating_modal.dart';

class SortNotesFloatModalSheet extends StatelessWidget {
  final List<String> sortName = ["Creation Date", "Modification date", "Alphabetical (A-Z)", "Alphabetical (Z-A)"];

  @override
  Widget build(BuildContext context) {
    final HydratedPrefsCubit _prefsCubit = BlocProvider.of<HydratedPrefsCubit>(context);

    var def = _prefsCubit.state.sortBy == 'created'
        ? 0.obs
        : _prefsCubit.state.sortBy == 'modified'
            ? 1.obs
            : _prefsCubit.state.sortBy == 'a-z'
                ? 2.obs
                : 3.obs;

    return PreferenceText(
      "Sort Notes",
      style: TextStyle(fontWeight: FontWeight.w600),
      titleGap: 0.0,
      leading: Icon(
        CupertinoIcons.sort_down_circle,
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
                  sortName[def.value],
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
      onTap: () => showFloatingModalBottomSheet(
        context: context,
        builder: (context) => Material(
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  centerTitle: true,
                  title: Text(
                    "SORT NOTES",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF222222), //TODO color
                      fontSize: 16.0,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(CupertinoIcons.clear, color: Color(0xFFA0A0A0)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Obx(
                  () => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // SizedBox(height: 10.0),
                      // tilesDivider(),
                      ListTile(
                        title: Text(
                          'Creation Date',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF222222),
                            fontSize: 15.0,
                          ),
                        ),
                        // horizontalTitleGap: 0.0,
                        tileColor: Colors.white,
                        onTap: () {
                          PrefService.setString(sortName[def.value], 'Date Created');
                          _prefsCubit.updateSortBy('created');
                          def.value = 0;
                        },
                        trailing: def.value == 0 ? Icon(CupertinoIcons.checkmark, color: Color(0xFFDD4C4F)) : null,
                      ),
                      tilesDivider(),
                      ListTile(
                        title: Text(
                          'Modification Date',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF222222),
                            fontSize: 15.0,
                          ),
                        ),
                        // horizontalTitleGap: 0.0,
                        tileColor: Colors.white,
                        onTap: () {
                          PrefService.setString(sortName[def.value], 'Date Modified');
                          _prefsCubit.updateSortBy('modified');
                          def.value = 1;
                        },
                        trailing: def.value == 1 ? Icon(CupertinoIcons.checkmark, color: Color(0xFFDD4C4F)) : null,
                      ),
                      tilesDivider(),
                      ListTile(
                        title: Text(
                          'Alphabetical (A-Z)',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF222222),
                            fontSize: 15.0,
                          ),
                        ),
                        // horizontalTitleGap: 0.0,
                        tileColor: Colors.white,
                        onTap: () {
                          PrefService.setString(sortName[def.value], 'Alphabetical (A-Z)');
                          _prefsCubit.updateSortBy('a-z');
                          def.value = 2;
                        },
                        trailing: def.value == 2 ? Icon(CupertinoIcons.checkmark, color: Color(0xFFDD4C4F)) : null,
                      ),
                      tilesDivider(),
                      ListTile(
                        title: Text(
                          'Alphabetical (Z-A)',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF222222),
                            fontSize: 15.0,
                          ),
                        ),
                        // horizontalTitleGap: 0.0,
                        tileColor: Colors.white,

                        onTap: () {
                          PrefService.setString(sortName[def.value], 'Alphabetical (Z-A)');
                          _prefsCubit.updateSortBy('z-a');
                          def.value = 3;
                        },
                        trailing: def.value == 3 ? Icon(CupertinoIcons.checkmark, color: Color(0xFFDD4C4F)) : null,
                      ),
                      tilesDivider(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Divider tilesDivider() {
    return Divider(
      height: 0.0,
      thickness: 1.0,
    );
  }
}
