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

  // ValueListenable<Box<NotesModel>> listenAllNotes() async {
  //   var box = await givnotesBox();
  //   return box.listenable();
  // }

  Future<int> insertNote(NotesModel note) async {
    var box = await givnotesBox();
    if (note != null) return await box.add(note);

    return -1;
  }

  Future updateNote(int index, NotesModel note) async {
    var box = await givnotesBox();
    if (note != null) await box.put(index, note);
  }

  Future deleteNote(int index) async {
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
