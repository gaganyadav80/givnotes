import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/screens/src/notes/src/notes_model.dart';
import 'package:givnotes/screens/src/notes/src/notes_repository.dart';

import 'notes/widgets/notes_card.dart';
import 'notes/widgets/notes_empty_view.dart';

class TrashView extends StatelessWidget {
  const TrashView({
    Key key,
    @required this.rootContext,
    @required this.modalController,
  }) : super(key: key);

  final BuildContext rootContext;
  final ScrollController modalController;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // backgroundColor: Colors.white,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Trash'),
        transitionBetweenRoutes: true,
        trailing: TextButton(
          child: 'Done'.text.color(Colors.blue).bold.make(),
          onPressed: () => Navigator.of(rootContext).pop(),
        ),
      ),
      child: GetBuilder<NotesController>(
        builder: (NotesController controller) {
          List<NotesModel> _notes = controller.notes.where((element) => element.trash == true).toList();

          if ((_notes.isEmpty)) {
            return NotesEmptyView(isTrash: true);
          }

          return CupertinoScrollbar(
            child: ListView.builder(
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              controller: modalController,
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final NotesModel note = _notes[index];

                return Slidable(
                  key: UniqueKey(),
                  actionPane: SlidableBehindActionPane(),
                  actionExtentRatio: 1.0,
                  dismissal: SlidableDismissal(
                    child: SlidableDrawerDismissal(),
                    onDismissed: (actionType) {
                      controller.updateNote(note.copyWith(trash: false));
                      Fluttertoast.showToast(msg: "moved to notes");
                    },
                  ),
                  secondaryActions: <Widget>[
                    iconSlideAction(Color(0xFF82C8F6), CupertinoIcons.arrow_up_bin, 'RESTORE'),
                  ],
                  child: NotesCard(note: note, index: index),
                );
              },
            ),
          );
        },
      ),
    );
  }

  IconSlideAction iconSlideAction(Color color, IconData icon, String caption) {
    return IconSlideAction(
      color: color,
      iconWidget: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 40.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white.withOpacity(0.9)),
                SizedBox(height: 15.0.w),
                Text(caption, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300)),
              ],
            ),
          )
        ],
      ),
      onTap: () => print('moved to Trash'),
    );
  }
}
