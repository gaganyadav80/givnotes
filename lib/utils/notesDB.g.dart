// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notesDB.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class givnotesDBAdapter extends TypeAdapter<givnotesDB> {
  @override
  final int typeId = 0;

  @override
  givnotesDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return givnotesDB(
      title: fields[0] as String,
      text: fields[1] as String,
      ftext: fields[2] as String,
      trash: fields[3] as bool,
      created: fields[4] as String,
      modified: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, givnotesDB obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.ftext)
      ..writeByte(3)
      ..write(obj.trash)
      ..writeByte(4)
      ..write(obj.created)
      ..writeByte(5)
      ..write(obj.modified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is givnotesDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
