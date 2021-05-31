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
      ..id = fields[0] as String
      ..title = fields[1] as String
      ..text = fields[2] as String
      ..znote = fields[3] as String
      ..trash = fields[4] as bool
      ..created = fields[5] as DateTime
      ..modified = fields[6] as DateTime
      ..tagsNameList = (fields[7] as List)?.cast<String>();
  }

  @override
  void write(BinaryWriter writer, NotesModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.znote)
      ..writeByte(4)
      ..write(obj.trash)
      ..writeByte(5)
      ..write(obj.created)
      ..writeByte(6)
      ..write(obj.modified)
      ..writeByte(7)
      ..write(obj.tagsNameList);
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

class PrefsModelAdapter extends TypeAdapter<PrefsModel> {
  @override
  final int typeId = 1;

  @override
  PrefsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrefsModel()
      ..biometric = fields[0] as bool
      ..passcode = fields[1] as String
      ..allTagsMap = (fields[2] as Map)?.cast<String, int>();
  }

  @override
  void write(BinaryWriter writer, PrefsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.biometric)
      ..writeByte(1)
      ..write(obj.passcode)
      ..writeByte(2)
      ..write(obj.allTagsMap);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrefsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
