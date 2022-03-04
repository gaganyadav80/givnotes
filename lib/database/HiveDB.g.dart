// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HiveDB.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrefsModelAdapter extends TypeAdapter<PrefsModel> {
  @override
  final int typeId = 0;

  @override
  PrefsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrefsModel()
      ..biometric = fields[0] as bool?
      ..passcode = fields[1] as String?
      ..allTagsMap = (fields[2] as Map?)?.cast<String, int>();
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
