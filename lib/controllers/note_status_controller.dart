import 'package:get/get.dart';
import 'package:givnotes/services/services.dart';

class NoteStatusController extends GetxController {
  static NoteStatusController get to => Get.find();

  NoteMode noteMode = NoteMode.adding;
  bool isEditing = false;

  void updateNoteMode(NoteMode value) {
    noteMode = value;
    update();
  }

  void updateIsEditing(bool value) {
    isEditing = value;
    update();
  }
}
