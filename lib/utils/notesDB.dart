import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String notesTable = 'NOTES';

class NotesDB {
  static Database db;

  static Future open() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'givnotes.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        db.execute('''
        CREATE TABLE $notesTable(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          text TEXT NOT NULL
        );
        ''');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getNoteList() async {
    if (db == null) {
      await open();
    }
    return await db.query(notesTable);
  }

  static Future insertNote(Map<String, dynamic> note) async {
    await db.insert(notesTable, note);
  }

  static Future updateNote(Map<String, dynamic> note) async {
    await db.update(
      notesTable,
      note,
      where: 'id = ?',
      whereArgs: [note['id']],
    );
  }

  static Future deleteNote(int id) async {
    await db.delete(
      notesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
