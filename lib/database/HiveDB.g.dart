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
      ..tagsMap = (fields[6] as Map)?.cast<String, int>();
  }

  @override
  void write(BinaryWriter writer, NotesModel obj) {
    writer
      ..writeByte(7)
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
      ..write(obj.tagsMap);
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
      ..isAnonymous = fields[0] as bool
      ..firstlaunch = fields[1] as bool
      ..applock = fields[2] as bool
      ..biometric = fields[3] as bool
      ..passcode = fields[4] as String
      ..allTagsMap = (fields[5] as Map)?.cast<String, int>();
  }

  @override
  void write(BinaryWriter writer, PrefsModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.isAnonymous)
      ..writeByte(1)
      ..write(obj.firstlaunch)
      ..writeByte(2)
      ..write(obj.applock)
      ..writeByte(3)
      ..write(obj.biometric)
      ..writeByte(4)
      ..write(obj.passcode)
      ..writeByte(5)
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
