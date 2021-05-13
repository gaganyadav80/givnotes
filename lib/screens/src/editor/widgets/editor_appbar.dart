import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class NoteEditorAppBar extends StatelessWidget with PreferredSizeWidget {
  final Function saveNote;
  const NoteEditorAppBar({
    @required this.saveNote,
    Key key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    // final noteEditStore = BlocProvider.of<NoteStatusCubit>(context);
    return AppBar(
      leadingWidth: 40.w,
      leading: IconButton(
        icon: Icon(CupertinoIcons.back),
        color: Colors.black,
        iconSize: 28.0,
        onPressed: saveNote,
      ),
      // leading: Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 8.5.w, vertical: 4.7.h),
      //   child: InkWell(
      //     onTap: () {
      //       saveNote();
      //     },
      //     child: FlareActor(
      //       'assets/animations/arrow-tick.flr',
      //       animation: noteEditStore.state.noteMode == NoteMode.Adding ? 'idle-tick' : 'idle-arrow',
      //       controller: controls,
      //       alignment: Alignment.center,
      //       fit: BoxFit.contain,
      //       // color: Theme.of(context).iconTheme.color,
      //     ),
      //   ),
      // ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.more_vert_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    );
  }
}
