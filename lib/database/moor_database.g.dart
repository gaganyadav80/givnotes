// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'moor_database.dart';

// // **************************************************************************
// // MoorGenerator
// // **************************************************************************

// // ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
// class NotesDBData extends DataClass implements Insertable<NotesDBData> {
//   final int id;
//   final String title;
//   final String note;
//   final String znote;
//   final bool trash;
//   final DateTime created;
//   final DateTime modified;
//   NotesDBData(
//       {this.id,
//       @required this.title,
//       @required this.note,
//       @required this.znote,
//       @required this.trash,
//       @required this.created,
//       this.modified});
//   factory NotesDBData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
//       {String prefix}) {
//     final effectivePrefix = prefix ?? '';
//     final intType = db.typeSystem.forDartType<int>();
//     final stringType = db.typeSystem.forDartType<String>();
//     final boolType = db.typeSystem.forDartType<bool>();
//     final dateTimeType = db.typeSystem.forDartType<DateTime>();
//     return NotesDBData(
//       id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
//       title:
//           stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
//       note: stringType.mapFromDatabaseResponse(data['${effectivePrefix}note']),
//       znote:
//           stringType.mapFromDatabaseResponse(data['${effectivePrefix}znote']),
//       trash: boolType.mapFromDatabaseResponse(data['${effectivePrefix}trash']),
//       created: dateTimeType
//           .mapFromDatabaseResponse(data['${effectivePrefix}created']),
//       modified: dateTimeType
//           .mapFromDatabaseResponse(data['${effectivePrefix}modified']),
//     );
//   }
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (!nullToAbsent || id != null) {
//       map['id'] = Variable<int>(id);
//     }
//     if (!nullToAbsent || title != null) {
//       map['title'] = Variable<String>(title);
//     }
//     if (!nullToAbsent || note != null) {
//       map['note'] = Variable<String>(note);
//     }
//     if (!nullToAbsent || znote != null) {
//       map['znote'] = Variable<String>(znote);
//     }
//     if (!nullToAbsent || trash != null) {
//       map['trash'] = Variable<bool>(trash);
//     }
//     if (!nullToAbsent || created != null) {
//       map['created'] = Variable<DateTime>(created);
//     }
//     if (!nullToAbsent || modified != null) {
//       map['modified'] = Variable<DateTime>(modified);
//     }
//     return map;
//   }

//   NotesDBCompanion toCompanion(bool nullToAbsent) {
//     return NotesDBCompanion(
//       id: id == null && nullToAbsent ? const Value.absent() : Value(id),
//       title:
//           title == null && nullToAbsent ? const Value.absent() : Value(title),
//       note: note == null && nullToAbsent ? const Value.absent() : Value(note),
//       znote:
//           znote == null && nullToAbsent ? const Value.absent() : Value(znote),
//       trash:
//           trash == null && nullToAbsent ? const Value.absent() : Value(trash),
//       created: created == null && nullToAbsent
//           ? const Value.absent()
//           : Value(created),
//       modified: modified == null && nullToAbsent
//           ? const Value.absent()
//           : Value(modified),
//     );
//   }

//   factory NotesDBData.fromJson(Map<String, dynamic> json,
//       {ValueSerializer serializer}) {
//     serializer ??= moorRuntimeOptions.defaultSerializer;
//     return NotesDBData(
//       id: serializer.fromJson<int>(json['id']),
//       title: serializer.fromJson<String>(json['title']),
//       note: serializer.fromJson<String>(json['note']),
//       znote: serializer.fromJson<String>(json['znote']),
//       trash: serializer.fromJson<bool>(json['trash']),
//       created: serializer.fromJson<DateTime>(json['created']),
//       modified: serializer.fromJson<DateTime>(json['modified']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer serializer}) {
//     serializer ??= moorRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'id': serializer.toJson<int>(id),
//       'title': serializer.toJson<String>(title),
//       'note': serializer.toJson<String>(note),
//       'znote': serializer.toJson<String>(znote),
//       'trash': serializer.toJson<bool>(trash),
//       'created': serializer.toJson<DateTime>(created),
//       'modified': serializer.toJson<DateTime>(modified),
//     };
//   }

//   NotesDBData copyWith(
//           {int id,
//           String title,
//           String note,
//           String znote,
//           bool trash,
//           DateTime created,
//           DateTime modified}) =>
//       NotesDBData(
//         id: id ?? this.id,
//         title: title ?? this.title,
//         note: note ?? this.note,
//         znote: znote ?? this.znote,
//         trash: trash ?? this.trash,
//         created: created ?? this.created,
//         modified: modified ?? this.modified,
//       );
//   @override
//   String toString() {
//     return (StringBuffer('NotesDBData(')
//           ..write('id: $id, ')
//           ..write('title: $title, ')
//           ..write('note: $note, ')
//           ..write('znote: $znote, ')
//           ..write('trash: $trash, ')
//           ..write('created: $created, ')
//           ..write('modified: $modified')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => $mrjf($mrjc(
//       id.hashCode,
//       $mrjc(
//           title.hashCode,
//           $mrjc(
//               note.hashCode,
//               $mrjc(
//                   znote.hashCode,
//                   $mrjc(trash.hashCode,
//                       $mrjc(created.hashCode, modified.hashCode)))))));
//   @override
//   bool operator ==(dynamic other) =>
//       identical(this, other) ||
//       (other is NotesDBData &&
//           other.id == this.id &&
//           other.title == this.title &&
//           other.note == this.note &&
//           other.znote == this.znote &&
//           other.trash == this.trash &&
//           other.created == this.created &&
//           other.modified == this.modified);
// }

// class NotesDBCompanion extends UpdateCompanion<NotesDBData> {
//   final Value<int> id;
//   final Value<String> title;
//   final Value<String> note;
//   final Value<String> znote;
//   final Value<bool> trash;
//   final Value<DateTime> created;
//   final Value<DateTime> modified;
//   const NotesDBCompanion({
//     this.id = const Value.absent(),
//     this.title = const Value.absent(),
//     this.note = const Value.absent(),
//     this.znote = const Value.absent(),
//     this.trash = const Value.absent(),
//     this.created = const Value.absent(),
//     this.modified = const Value.absent(),
//   });
//   NotesDBCompanion.insert({
//     this.id = const Value.absent(),
//     @required String title,
//     @required String note,
//     @required String znote,
//     this.trash = const Value.absent(),
//     @required DateTime created,
//     this.modified = const Value.absent(),
//   })  : title = Value(title),
//         note = Value(note),
//         znote = Value(znote),
//         created = Value(created);
//   static Insertable<NotesDBData> custom({
//     Expression<int> id,
//     Expression<String> title,
//     Expression<String> note,
//     Expression<String> znote,
//     Expression<bool> trash,
//     Expression<DateTime> created,
//     Expression<DateTime> modified,
//   }) {
//     return RawValuesInsertable({
//       if (id != null) 'id': id,
//       if (title != null) 'title': title,
//       if (note != null) 'note': note,
//       if (znote != null) 'znote': znote,
//       if (trash != null) 'trash': trash,
//       if (created != null) 'created': created,
//       if (modified != null) 'modified': modified,
//     });
//   }

//   NotesDBCompanion copyWith(
//       {Value<int> id,
//       Value<String> title,
//       Value<String> note,
//       Value<String> znote,
//       Value<bool> trash,
//       Value<DateTime> created,
//       Value<DateTime> modified}) {
//     return NotesDBCompanion(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       note: note ?? this.note,
//       znote: znote ?? this.znote,
//       trash: trash ?? this.trash,
//       created: created ?? this.created,
//       modified: modified ?? this.modified,
//     );
//   }

//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (id.present) {
//       map['id'] = Variable<int>(id.value);
//     }
//     if (title.present) {
//       map['title'] = Variable<String>(title.value);
//     }
//     if (note.present) {
//       map['note'] = Variable<String>(note.value);
//     }
//     if (znote.present) {
//       map['znote'] = Variable<String>(znote.value);
//     }
//     if (trash.present) {
//       map['trash'] = Variable<bool>(trash.value);
//     }
//     if (created.present) {
//       map['created'] = Variable<DateTime>(created.value);
//     }
//     if (modified.present) {
//       map['modified'] = Variable<DateTime>(modified.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('NotesDBCompanion(')
//           ..write('id: $id, ')
//           ..write('title: $title, ')
//           ..write('note: $note, ')
//           ..write('znote: $znote, ')
//           ..write('trash: $trash, ')
//           ..write('created: $created, ')
//           ..write('modified: $modified')
//           ..write(')'))
//         .toString();
//   }
// }

// class $NotesDBTable extends NotesDB with TableInfo<$NotesDBTable, NotesDBData> {
//   final GeneratedDatabase _db;
//   final String _alias;
//   $NotesDBTable(this._db, [this._alias]);
//   final VerificationMeta _idMeta = const VerificationMeta('id');
//   GeneratedIntColumn _id;
//   @override
//   GeneratedIntColumn get id => _id ??= _constructId();
//   GeneratedIntColumn _constructId() {
//     return GeneratedIntColumn(
//       'id',
//       $tableName,
//       true,
//     );
//   }

//   final VerificationMeta _titleMeta = const VerificationMeta('title');
//   GeneratedTextColumn _title;
//   @override
//   GeneratedTextColumn get title => _title ??= _constructTitle();
//   GeneratedTextColumn _constructTitle() {
//     return GeneratedTextColumn(
//       'title',
//       $tableName,
//       false,
//     );
//   }

//   final VerificationMeta _noteMeta = const VerificationMeta('note');
//   GeneratedTextColumn _note;
//   @override
//   GeneratedTextColumn get note => _note ??= _constructNote();
//   GeneratedTextColumn _constructNote() {
//     return GeneratedTextColumn(
//       'note',
//       $tableName,
//       false,
//     );
//   }

//   final VerificationMeta _znoteMeta = const VerificationMeta('znote');
//   GeneratedTextColumn _znote;
//   @override
//   GeneratedTextColumn get znote => _znote ??= _constructZnote();
//   GeneratedTextColumn _constructZnote() {
//     return GeneratedTextColumn(
//       'znote',
//       $tableName,
//       false,
//     );
//   }

//   final VerificationMeta _trashMeta = const VerificationMeta('trash');
//   GeneratedBoolColumn _trash;
//   @override
//   GeneratedBoolColumn get trash => _trash ??= _constructTrash();
//   GeneratedBoolColumn _constructTrash() {
//     return GeneratedBoolColumn('trash', $tableName, false,
//         defaultValue: const Constant(false));
//   }

//   final VerificationMeta _createdMeta = const VerificationMeta('created');
//   GeneratedDateTimeColumn _created;
//   @override
//   GeneratedDateTimeColumn get created => _created ??= _constructCreated();
//   GeneratedDateTimeColumn _constructCreated() {
//     return GeneratedDateTimeColumn(
//       'created',
//       $tableName,
//       false,
//     );
//   }

//   final VerificationMeta _modifiedMeta = const VerificationMeta('modified');
//   GeneratedDateTimeColumn _modified;
//   @override
//   GeneratedDateTimeColumn get modified => _modified ??= _constructModified();
//   GeneratedDateTimeColumn _constructModified() {
//     return GeneratedDateTimeColumn(
//       'modified',
//       $tableName,
//       true,
//     );
//   }

//   @override
//   List<GeneratedColumn> get $columns =>
//       [id, title, note, znote, trash, created, modified];
//   @override
//   $NotesDBTable get asDslTable => this;
//   @override
//   String get $tableName => _alias ?? 'notes_d_b';
//   @override
//   final String actualTableName = 'notes_d_b';
//   @override
//   VerificationContext validateIntegrity(Insertable<NotesDBData> instance,
//       {bool isInserting = false}) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('id')) {
//       context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
//     }
//     if (data.containsKey('title')) {
//       context.handle(
//           _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
//     } else if (isInserting) {
//       context.missing(_titleMeta);
//     }
//     if (data.containsKey('note')) {
//       context.handle(
//           _noteMeta, note.isAcceptableOrUnknown(data['note'], _noteMeta));
//     } else if (isInserting) {
//       context.missing(_noteMeta);
//     }
//     if (data.containsKey('znote')) {
//       context.handle(
//           _znoteMeta, znote.isAcceptableOrUnknown(data['znote'], _znoteMeta));
//     } else if (isInserting) {
//       context.missing(_znoteMeta);
//     }
//     if (data.containsKey('trash')) {
//       context.handle(
//           _trashMeta, trash.isAcceptableOrUnknown(data['trash'], _trashMeta));
//     }
//     if (data.containsKey('created')) {
//       context.handle(_createdMeta,
//           created.isAcceptableOrUnknown(data['created'], _createdMeta));
//     } else if (isInserting) {
//       context.missing(_createdMeta);
//     }
//     if (data.containsKey('modified')) {
//       context.handle(_modifiedMeta,
//           modified.isAcceptableOrUnknown(data['modified'], _modifiedMeta));
//     }
//     return context;
//   }

//   @override
//   Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
//   @override
//   NotesDBData map(Map<String, dynamic> data, {String tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
//     return NotesDBData.fromData(data, _db, prefix: effectivePrefix);
//   }

//   @override
//   $NotesDBTable createAlias(String alias) {
//     return $NotesDBTable(_db, alias);
//   }
// }

// abstract class _$GivnotesDatabase extends GeneratedDatabase {
//   _$GivnotesDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
//   $NotesDBTable _notesDB;
//   $NotesDBTable get notesDB => _notesDB ??= $NotesDBTable(this);
//   @override
//   Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
//   @override
//   List<DatabaseSchemaEntity> get allSchemaEntities => [notesDB];
// }
