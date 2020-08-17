import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

part 'notesDB.g.dart';

// Flutter secure storage
final storage = FlutterSecureStorage();
//

// Hive
@HiveType(typeId: 0)
class givnotesDB {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final String ftext;

  @HiveField(3)
  final bool trash;

  @HiveField(4)
  final String created;

  @HiveField(5)
  final String modified;

  givnotesDB({this.title, this.text, this.ftext, this.trash = false, this.created, this.modified});
}
//

// SQFlite
final String notesTable = 'notes';

class NotesDB {
  static Database db;

  static Future open() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'givnotes.db'),
      version: 1,
      // TODO: create different table for each user and one for non-user
      onCreate: (Database db, int version) async {
        db.execute('''
        CREATE TABLE $notesTable(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          text TEXT NOT NULL,
          trash BOOLEAN DEFAULT 0,
          created TEXT NOT NULL,
          modified TEXT NOT NULL
        );
        ''');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getNoteList() async {
    if (db == null) {
      await open();
    }
    return await db.query(
      notesTable,
      where: 'trash = ?',
      whereArgs: [0],
    );
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

  static Future<List<Map<String, dynamic>>> getTrashNoteList() async {
    return await db.query(
      notesTable,
      where: 'trash = ?',
      whereArgs: [1],
    );
  }

  static Future<List<Map<String, dynamic>>> getItemToRename(Map<String, dynamic> note) async {
    return await db.query(
      notesTable,
      where: 'title = ? AND text = ? AND created = ?',
      whereArgs: [note['title'], note['text'], note['created']],
    );
  }
}

// static Future trashNote(Map<String, dynamic> note) async {
//   await db.update(
//     notesTable,
//     note,
//     where: 'id = ?',
//     whereArgs: [note['id']],
//   );
// }
