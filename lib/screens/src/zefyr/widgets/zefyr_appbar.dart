import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/cubit/note_search_cubit/note_search_cubit.dart';
import 'package:givnotes/global/size_utils.dart';
import 'package:givnotes/global/variables.dart';

class ZefyrEditAppBar extends StatelessWidget with PreferredSizeWidget {
  final Function saveNote;
  final FlareControls controls;
  const ZefyrEditAppBar({
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
        // padding: EdgeInsets.fromLTRB(8.5, 4.7, 8.5, 4.7),
        padding: EdgeInsets.fromLTRB(0.021573604 * screenSize.width, 0.006184211 * screenSize.height, 0.021573604 * screenSize.width, 0.006184211 * screenSize.height),
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
