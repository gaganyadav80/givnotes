import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:givnotes/cubit/note_search_cubit/note_search_cubit.dart';
import 'package:givnotes/global/variables.dart';

class NoteEditorAppBar extends StatelessWidget with PreferredSizeWidget {
  final Function saveNote;
  final FlareControls controls;
  const NoteEditorAppBar({
    @required this.saveNote,
    @required this.controls,
    Key key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    final noteEditStore = BlocProvider.of<NoteAndSearchCubit>(context);
    return AppBar(
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.5.w, vertical: 4.7.h),
        child: InkWell(
          onTap: () {
            saveNote();
          },
          child: FlareActor(
            'assets/animations/arrow-tick.flr',
            animation: noteEditStore.state.noteMode == NoteMode.Adding ? 'idle-tick' : 'idle-arrow',
            controller: controls,
            alignment: Alignment.center,
            fit: BoxFit.contain,
            // color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.more_vert,
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
