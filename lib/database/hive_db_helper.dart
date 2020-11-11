import 'package:givnotes/database/HiveDB.dart';
import 'package:hive/hive.dart';

class HiveDBServices {
  // String _prefsBoxName = 'prefs';
  String _givnotesBoxName = 'givnnotes';

  /*
  Notes
  */
  Future<Box> givnotesBox() async {
    var box = Hive.openBox<NotesModel>(_givnotesBoxName);
    return box;
  }

  Future<bool> closeBox() async {
    var box = await givnotesBox();
    box.close();
    return !box.isOpen;
  }

  Future<List<NotesModel>> getAllNotes() async {
    var box = await givnotesBox();
    return box.values.where((element) => element.trash = false).toList();
  }

  Future<NotesModel> insertNote(NotesModel note) async {
    var box = await givnotesBox();
    if (note != null) await box.add(note);

    return note;
  }

  Future<NotesModel> updateNote(dynamic index, NotesModel note) async {
    var box = await givnotesBox();
    if (note != null) await box.put(index, note);

    return note;
  }

  Future deleteNote(dynamic index) async {
    var box = await givnotesBox();
    await box.delete(index);
  }

  /*
  Prefs
  */
  // Future<Box> prefsBox() async {
  //   var box = Hive.openBox<PrefsModel>(_prefsBoxName);
  //   return box;
  // }

  // Future updatePrefs(PrefsModel prefs) async {
  //   var box = await prefsBox();
  //   if (prefs != null) await box.putAll(prefs.toJson());
  // }

  // Future<ValueListenable<Box<NotesModel>>> listenToPrefs() async {
  //   var box = await prefsBox();
  //   return box.listenable();
  // }
}
