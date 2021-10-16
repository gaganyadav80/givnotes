import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        middle: const Text('Trash'),
        transitionBetweenRoutes: true,
        trailing: TextButton(
          child: 'Done'.text.color(Colors.blue).bold.make(),
          onPressed: () => Navigator.of(rootContext).pop(),
        ),
      ),
      child: GetBuilder<NotesController>(
        builder: (NotesController controller) {
          List<NotesModel> _notes = controller.notes
              .where((element) => element.trash == true)
              .toList();

          if ((_notes.isEmpty)) {
            return const NotesEmptyView(isTrash: true);
          }

          return CupertinoScrollbar(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              controller: modalController,
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final NotesModel note = _notes[index];

                return Slidable(
                  key: UniqueKey(),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.25,
                    children: <Widget>[
                      iconSlideAction(const Color(0xFF82C8F6),
                          CupertinoIcons.arrow_up_bin, 'RESTORE', () {
                        controller.updateNote(note.copyWith(trash: false));
                        Fluttertoast.showToast(msg: "moved to notes");
                      }),
                    ],
                  ),
                  child: NotesCard(note: note, showTags: true),
                );
              },
            ),
          );
        },
      ),
    );
  }

  CustomSlidableAction iconSlideAction(
      Color color, IconData icon, String caption, VoidCallback onTap) {
    return CustomSlidableAction(
      backgroundColor: color,
      child: <Widget>[
        Icon(icon),
        const SizedBox(height: 8),
        caption.text.light.make(),
      ].vStack(axisSize: MainAxisSize.min),
      onPressed: (_) => onTap(),
    );
  }
}
