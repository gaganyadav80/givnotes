// import 'dart:async';
// import 'package:givnotes/variables/homeVariables.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite_sqlcipher/sqflite.dart';
// import 'package:sqlbrite/sqlbrite.dart';

// String notesTable = 'notes';

// class NotesDB {
//   static Database db;

//   static Future open() async {
//     db = await openDatabase(
//       join(await getDatabasesPath(), 'givnotes.db'),
//       password: '87755c1d-acc9-4fa1-8eb3-8905a22e64b0',
//       version: 1,
//       // TODO: create different table for each user and one for non-user
//       onCreate: (Database db, int version) async {
//         db.execute('''
//         CREATE TABLE $notesTable(
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           title TEXT NOT NULL,
//           text TEXT NOT NULL,
//           znote TEXT NOT NULL,
//           trash BOOLEAN DEFAULT 0,
//           created TEXT NOT NULL,
//           modified TEXT NOT NULL
//         );
//         ''');
//       },
//     );
//   }

//   static Future<List<Map<String, dynamic>>> getNoteList() async {
//     if (db == null) {
//       await open();
//     }
//     return await db.query(
//       notesTable,
//       where: 'trash = ?',
//       // whereArgs: [0],
//       whereArgs: Var.isTrash ? [1] : [0],
//     );
//   }

//   static Future insertNote(Map<String, dynamic> note) async {
//     await db.insert(notesTable, note);
//   }

//   static Future updateNote(Map<String, dynamic> note) async {
//     await db.update(
//       notesTable,
//       note,
//       where: 'id = ?',
//       whereArgs: [note['id']],
//     );
//   }

//   static Future deleteNote(int id) async {
//     await db.delete(
//       notesTable,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
// }

/*
  SQLBrite
 */
// Future<Database> _open() async {
//   final directory = await getApplicationDocumentsDirectory();
//   final path = join(directory.path, 'givnotes3.db');

//   return await openDatabase(
//     // join((await getApplicationDocumentsDirectory()).path, 'givnotes3.db'),
//     path,
//     password: '87755c1d-acc9-4fa1-8eb3-8905a22e64b0',
//     version: 1,
//     // TODO: create different table for each user and one for non-user
//     onCreate: (Database _db, int version) async {
//       _db.execute('''
//         CREATE TABLE $notesTable(
//           id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
//           title TEXT NOT NULL,
//           text TEXT NOT NULL,
//           znote TEXT NOT NULL,
//           trash BOOLEAN DEFAULT 0,
//           created TEXT NOT NULL,
//           modified TEXT NOT NULL
//         );
//         ''');
//     },
//   );
// }

// class NotesDb {
//   static NotesDb _singleton;

//   NotesDb._();

//   factory NotesDb.getInstance() => _singleton ??= NotesDb._();

//   // static Database db;
//   // static BriteDatabase briteDb;

//   final _dbFuture = _open().then((_db) => BriteDatabase(_db));

//   Stream<List<Note>> getAllNotes() async* {
//     final db = await _dbFuture;
//     yield* db
//         .createQuery(
//           notesTable,
//           // orderBy: 'created DESC',
//         )
//         .mapToList((json) => Note.fromJson(json));
//   }

//   Future<int> insertNote(Note note) async {
//     final db = await _dbFuture;
//     final id = await db.insert(
//       notesTable,
//       note.toJson(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     // return id != -1;
//     return id;
//   }

//   Future<bool> deleteNote(Note note) async {
//     final db = await _dbFuture;
//     final rows = await db.delete(
//       notesTable,
//       where: 'id = ?',
//       whereArgs: [note.id],
//     );
//     return rows > 0;
//   }

//   Future<bool> updateNote(Note note) async {
//     final db = await _dbFuture;
//     final rows = await db.update(
//       notesTable,
//       note.toJson(),
//       where: 'id = ?',
//       whereArgs: [note.id],
//       // conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     return rows > 0;
//   }
// }

// class Note {
//   final int id;
//   final String title;
//   final String text;
//   final String znote;
//   final bool trash;
//   final DateTime created;
//   final DateTime modified;

//   const Note({
//     this.id,
//     this.title,
//     this.text,
//     this.znote,
//     this.trash,
//     this.created,
//     this.modified,
//   });

//   factory Note.fromJson(Map<String, dynamic> json) {
//     return Note(
//       id: json['id'],
//       title: json['title'],
//       text: json['text'],
//       znote: json['znote'],
//       trash: json['trash'],
//       created: DateTime.parse(json['created']),
//       modified: DateTime.parse(json['modified']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       if (id != null) 'id': id,
//       'title': title,
//       'text': text,
//       'znote': znote,
//       'trash': trash,
//       'created': created.toIso8601String(),
//       'modified': modified.toIso8601String(),
//     };
//   }

//   Note copyWith(String content) => Note(
//         id: id,
//         title: title,
//         text: text,
//         znote: znote,
//         trash: trash,
//         created: created,
//         modified: modified,
//       );

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Note &&
//           runtimeType == other.runtimeType &&
//           id == other.id &&
//           title == other.title &&
//           text == other.text &&
//           znote == other.znote &&
//           trash == other.trash &&
//           created == other.created &&
//           modified == other.modified;

//   @override
//   int get hashCode => id.hashCode ^ title.hashCode ^ text.hashCode ^ znote.hashCode ^ trash.hashCode ^ created.hashCode ^ modified.hashCode;

//   @override
//   String toString() => 'Note{id: $id, title: $title, text: $text, znote: $znote, trash: $trash, created: $created, modified: $modified}';
// }
