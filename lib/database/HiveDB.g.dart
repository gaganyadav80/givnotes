// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HiveDB.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotesModelAdapter extends TypeAdapter<NotesModel> {
  @override
  final int typeId = 0;

  @override
  NotesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotesModel()
      ..title = fields[0] as String
      ..text = fields[1] as String
      ..znote = fields[2] as String
      ..trash = fields[3] as bool
      ..created = fields[4] as DateTime
      ..modified = fields[5] as DateTime
      ..tags = (fields[6] as List)?.cast<String>()
      ..tagColor = (fields[7] as List)?.cast<int>();
  }

  @override
  void write(BinaryWriter writer, NotesModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.znote)
      ..writeByte(3)
      ..write(obj.trash)
      ..writeByte(4)
      ..write(obj.created)
      ..writeByte(5)
      ..write(obj.modified)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.tagColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
