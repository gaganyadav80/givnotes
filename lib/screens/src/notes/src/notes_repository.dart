import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'notes_model.dart';

class NotesController extends GetxController {
  List<NotesModel> notes = <NotesModel>[];

  /// To preserve the sortby choice by the user and sort the note when user adds/updates the note
  int _sortby = 0;

  /// Store the user specific directory for notes json and only update when user changes.
  Directory _directory;

  /// Stream to listen to user changes and update the notes directory as such.
  StreamSubscription<User> _dirSubscription;

  @override
  void onInit() {
    _getDirectory(null).then((value) => _directory = value);
    _dirSubscription =
        FirebaseAuth.instance.userChanges().listen((User event) async {
      _directory = await _getDirectory(event?.uid);
      getAllNotes();
    });
    super.onInit();
  }

  @override
  void onClose() {
    _dirSubscription?.cancel();
    super.onClose();
  }

  Future<Directory> _getDirectory(String userID) async {
    return Directory((await getApplicationDocumentsDirectory()).path +
            "/givnotesdb/${userID ?? "default"}")
        .create(recursive: true);
  }

  Directory get directory => _directory;
  // Directory("/data/user/0/com.gaganyadav.givnotes/app_flutter/").create(recursive: true);

  Future<File> _getFile(String noteid) async {
    // Directory dir = await directory;
    return File(_directory.path + "/$noteid.json").create();
  }

  //Sort on init inside CheckLogin build method
  set sortby(int value) {
    _sortby = value;
    sort();
  }

  void getAllNotes() async {
    // this._directory = await _getDirectory(userID);
    notes.clear();
    notes.addAll(_directory
        .listSync()
        .map((e) =>
            NotesModel.fromJson(json.decode(File(e.path).readAsStringSync())))
        .where((element) => element.trash == false)
        .toList());

    update();
  }

  void sort() {
    if (_sortby == 0) {
      notes.sort((a, b) => b.created.compareTo(a.created));
    } else if (_sortby == 1) {
      notes.sort((a, b) => b.modified.compareTo(a.modified));
    } else if (_sortby == 2) {
      notes.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sortby == 3) {
      notes.sort((a, b) => b.title.compareTo(a.title));
    } else {
      notes.sort((a, b) => b.created.compareTo(a.created));
    }

    update();
  }

  Future<void> addNewNote(NotesModel note) async {
    notes.add(note);
    sort();
    update();
    return (await _getFile(note.id)).writeAsString(json.encode(note.toJson()));
  }

  Future<void> deleteNote(String id) async {
    notes.removeWhere((element) => element.id == id);
    update();
    return (await _getFile(id)).delete();
  }

  Future<void> updateNote(NotesModel note) async {
    notes.removeWhere((element) => element.id == note.id);
    notes.add(note); //update note
    sort(); //sort the updated list
    update(); //update the UI
    return (await _getFile(note.id)).writeAsString(json.encode(note.toJson()));
  }
}
