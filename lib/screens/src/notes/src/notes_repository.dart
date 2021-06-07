import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'notes_model.dart';

class NotesController extends GetxController {
  List<NotesModel> notes = <NotesModel>[];
  int _sortby = 0;

  @override
  void onInit() {
    _getAllNotes();
    super.onInit();
  }

  set sortby(int value) {
    _sortby = value;
    sort(value);
  }

  void _getAllNotes() {
    directory.then((value) {
      notes.clear();
      notes.addAll(value
          .listSync()
          .map((e) => NotesModel.fromJson(json.decode(File(e.path).readAsStringSync())))
          .where((element) => element.trash == false)
          .toList());
    });
  }

  void sort(int value) {
    if (value == 0)
      notes.sort((a, b) => b.created.compareTo(a.created));
    else if (value == 1)
      notes.sort((a, b) => b.modified.compareTo(a.modified));
    else if (value == 2)
      notes.sort((a, b) => a.title.compareTo(b.title));
    else if (value == 3) {
      notes.sort((a, b) => b.title.compareTo(a.title));
    } else
      notes.sort((a, b) => b.created.compareTo(a.created));

    update();
  }

  Future<Directory> get directory => Directory(
          "/data/user/0/com.gaganyadav.givnotes/app_flutter/givnotesdb/${FirebaseAuth.instance.currentUser?.uid ?? "default"}")
      .create(recursive: true);

  Future<File> getFile(String id) async {
    Directory dir = await directory;
    return File(dir.path + "/$id.json").create();
  }

  Future<void> addNewNote(NotesModel note) async {
    notes.add(note);
    sort(_sortby);
    update();
    return (await getFile(note.id)).writeAsString(json.encode(note.toJson()));
  }

  Future<void> deleteNote(String id) async {
    notes.removeWhere((element) => element.id == id);
    update();
    return (await getFile(id)).delete();
  }

  Future<void> updateNote(NotesModel note) async {
    notes.removeWhere((element) => element.id == note.id);
    notes.add(note); //update note
    sort(_sortby); //sort the updated list
    update(); //update the UI
    return (await getFile(note.id)).writeAsString(json.encode(note.toJson()));
  }
}