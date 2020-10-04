// import 'package:moor_flutter/moor_flutter.dart';

// part 'moor_database.g.dart';

// class NotesDB extends Table {
//   IntColumn get id => integer().nullable()();
//   TextColumn get title => text()();
//   TextColumn get note => text()();
//   TextColumn get znote => text()();
//   BoolColumn get trash => boolean().withDefault(const Constant(false))();
//   DateTimeColumn get created => dateTime()();
//   DateTimeColumn get modified => dateTime().nullable()();
// }

// @UseMoor(tables: [NotesDB])
// class GivnotesDatabase extends _$GivnotesDatabase {
//   // TODO set logStatements to false when done
//   GivnotesDatabase() : super(FlutterQueryExecutor.inDatabaseFolder(path: 'givnotes.sqlite', logStatements: true));

//   @override
//   int get schemaVersion => 1;

//   Future<List<NotesDBData>> getNoteList() => select(notesDB).get();
//   Stream<List<NotesDBData>> watchNoteList() => (select(notesDB)).watch();
//   Stream<List<NotesDBData>> watchTrashNoteList() => (select(notesDB)..where((t) => t.trash.equals(true))).watch();
//   Future insertNote(NotesDBData notesDBData) => into(notesDB).insert(notesDBData);
//   Future updateNote(NotesDBData notesDBData) => update(notesDB).replace(notesDBData);
//   Future deleteNote(NotesDBData notesDBData) => delete(notesDB).delete(notesDBData);
// }

// // await database.insertNote(NotesDBCompanion(
// //             title: Value('title'),
// //             note: Value('note'),
// //             znote: Value('znote'),
// //             created: Value(DateTime.now()),
// //             trash: Value(false),
// //           ));

// // database.updateNote(Var.note.copyWith(
// //             title: "title",
// //             note: "_zefyrController.document.toPlainText()",
// //             znote: "jsonEncode(_zefyrController.document)",
// //             created: DateTime.now(),
// //             modified: DateTime.now(),
// //             trash: false,
// //           ));

// // await database.updateNote(note.copyWith(trash: true));
