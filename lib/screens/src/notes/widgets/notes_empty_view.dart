import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/global/utils.dart';

class NotesEmptyView extends StatelessWidget {
  const NotesEmptyView({Key key, @required this.isTrash}) : super(key: key);

  final bool isTrash;

  @override
  Widget build(BuildContext context) {
    final hm = 7.6;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    // final wm = 3.93;
    return BlocProvider.of<HomeCubit>(context).state.global == true
        ? Center(child: Container(child: Text("Global")))
        : isTrash
            ? SafeArea(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Center(
                        child: Text(
                          "You don't have any trash",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 2.0 * hm,
                          ),
                        ),
                      ),
                      // SizedBox(height: 0.5 * hm),
                      SizedBox(height: 0.005 * screenSize.height),
                      Center(
                        child: Text(
                          "Create 'em, trash 'em. See them",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 1.5 * hm,
                          ),
                        ),
                      ),
                      // SizedBox(height: 30 * hm),
                      SizedBox(height: 0.3 * screenSize.height),
                      Padding(
                        // padding: EdgeInsets.only(bottom: hm),
                        padding: EdgeInsets.only(bottom: 0.01 * screenSize.height),
                        child: Image(
                          image: isDark ? AssetImage('assets/giv_img/empty_trash_dark.png') : AssetImage('assets/giv_img/empty_trash_light.png'),
                          // height: 25 * hm,
                          // width: 45 * wm,
                          height: 0.25 * screenSize.height,
                          width: 0.45 * screenSize.width,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            //TODO change this after testing
            : BlocBuilder<HydratedPrefsCubit, HydratedPrefsState>(
                builder: (context, state) {
                  return Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          isDark ? 'assets/giv_img/empty_notes_dark.png' : 'assets/giv_img/empty_notes_light.png',
                          width: 0.75 * screenSize.width,
                          height: 0.336973684 * screenSize.height,
                        ),
                        Text("Notes sorted by: ${state.sortBy}"),
                        Text("Compact Tags: ${state.compactTags}"),
                      ],
                    ),
                  );
                },
              );
  }
}
