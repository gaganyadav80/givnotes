import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:givnotes/controllers/controllers.dart';

class NoteEditorAppBar extends StatelessWidget with PreferredSizeWidget {
  final VoidCallback saveNote;
  const NoteEditorAppBar({
    required this.saveNote,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    // final noteEditStore = BlocProvider.of<NoteStatusCubit>(context);
    return AppBar(
      leadingWidth: 40.w,
      leading: GetBuilder<NoteStatusController>(
        builder: (NoteStatusController state) {
          return IconButton(
            icon: Icon(state.isEditing ? CupertinoIcons.checkmark_alt : CupertinoIcons.back),
            color: Colors.black,
            iconSize: 28.0,
            onPressed: saveNote,
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(
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
