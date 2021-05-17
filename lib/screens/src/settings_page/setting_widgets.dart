import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/global/variables.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/widgets/widgets.dart';

class SortNotesFloatModalSheet extends StatelessWidget {
  final TextStyle _kListItemStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
    color: Color(0xFF222222),
    fontSize: 15.w,
  );
  @override
  Widget build(BuildContext context) {
    final HydratedPrefsCubit _prefsCubit = BlocProvider.of<HydratedPrefsCubit>(context);

    var def = _prefsCubit.state.sortBy.obs;

    return PreferenceText(
      "Sort Notes",
      style: TextStyle(fontWeight: FontWeight.w600),
      titleGap: 0.0,
      leading: Icon(
        CupertinoIcons.sort_down_circle,
        color: Theme.of(context).textTheme.bodyText1.color,
      ),
      trailing: Container(
        width: 200.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: Obx(
                () => Text(
                  sortbyNames[def.value],
                  style: TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 15.w,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            Icon(
              CupertinoIcons.forward,
              size: 21.w,
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
                CupertinoNavigationBar(
                  automaticallyImplyLeading: false,
                  padding: EdgeInsetsDirectional.zero,
                  border: Border.all(color: Colors.white, width: 0.0),
                  backgroundColor: Colors.white,
                  middle: Text(
                    "SORT NOTES",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF222222),
                      fontSize: 18.w,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(CupertinoIcons.clear, color: Color(0xFFA0A0A0)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Obx(
                  () => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text(
                          'Creation Date',
                          style: _kListItemStyle,
                        ),
                        tileColor: Colors.white,
                        onTap: () {
                          def.value = 0;
                          _prefsCubit.updateSortBy(0);
                        },
                        trailing: def.value == 0 ? Icon(CupertinoIcons.checkmark, color: Color(0xFFDD4C4F)) : null,
                      ),
                      tilesDivider(),
                      ListTile(
                        title: Text(
                          'Modification Date',
                          style: _kListItemStyle,
                        ),
                        tileColor: Colors.white,
                        onTap: () {
                          _prefsCubit.updateSortBy(1);
                          def.value = 1;
                        },
                        trailing: def.value == 1 ? Icon(CupertinoIcons.checkmark, color: Color(0xFFDD4C4F)) : null,
                      ),
                      tilesDivider(),
                      ListTile(
                        title: Text(
                          'Alphabetical (A-Z)',
                          style: _kListItemStyle,
                        ),
                        tileColor: Colors.white,
                        onTap: () {
                          _prefsCubit.updateSortBy(2);
                          def.value = 2;
                        },
                        trailing: def.value == 2 ? Icon(CupertinoIcons.checkmark, color: Color(0xFFDD4C4F)) : null,
                      ),
                      tilesDivider(),
                      ListTile(
                        title: Text(
                          'Alphabetical (Z-A)',
                          style: _kListItemStyle,
                        ),
                        tileColor: Colors.white,
                        onTap: () {
                          _prefsCubit.updateSortBy(3);
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
      indent: 15.w,
    );
  }
}

class SettingsTileDivider extends StatelessWidget {
  const SettingsTileDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      endIndent: 20.w,
      indent: 20.w,
      thickness: 0.5,
      height: 5.w,
    );
  }
}
