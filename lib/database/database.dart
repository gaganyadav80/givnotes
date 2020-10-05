import 'dart:io';
import 'package:givnotes/variables/homeVariables.dart';
import 'package:givnotes/models/notes_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDBProvider {
  String notesTable = 'notes';

  // Create a singleton
  NotesDBProvider._();

  static final NotesDBProvider db = NotesDBProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, 'givnotes.db');

    return await openDatabase(
      // join(await getDatabasesPath(), 'givnotes.db'),
      // password: '87755c1d-acc9-4fa1-8eb3-8905a22e64b0',
      path,
      version: 1,
      onOpen: (db) async {},
      // TODO: create different table for each user and one for non-user
      onCreate: (Database db, int version) async {
        db.execute('''
        CREATE TABLE $notesTable(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          text TEXT NOT NULL,
          znote TEXT NOT NULL,
          trash BOOLEAN DEFAULT 0,
          created TEXT NOT NULL,
          modified TEXT NOT NULL
        );
        ''');
      },
    );
  }

  // Notes
  newNote(Note note) async {
    final db = await database;
    var res = await db.insert(notesTable, note.toJson());

    return res;
  }

  getNotes() async {
    final db = await database;
    var res = await db.query(notesTable, where: 'trash = ?', whereArgs: Var.isTrash ? [1] : [0]);
    List<Note> notes = res.isNotEmpty ? res.map((note) => Note.fromJson(note)).toList() : [];

    return notes;
  }

  getNote(int id) async {
    final db = await database;
    var res = await db.query('note', where: 'id = ?', whereArgs: [id]);
    // var res = await db.query(notesTable, where: 'trash = ?', whereArgs: Var.isTrash ? [1] : [0]);

    return res.isNotEmpty ? Note.fromJson(res.first) : null;
  }

  updateNote(Note note) async {
    final db = await database;
    var res = await db.update(notesTable, note.toJson(), where: 'id = ?', whereArgs: [note.id]);

    return res;
  }

  deleteNote(int id) async {
    final db = await database;

    db.delete(notesTable, where: 'id = ?', whereArgs: [id]);
  }
}
