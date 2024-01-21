// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_dto_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemeDTOLocalAdapter extends TypeAdapter<ThemeDTOLocal> {
  @override
  final int typeId = 2;

  @override
  ThemeDTOLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemeDTOLocal(
      id: fields[0] as String,
      type: fields[1] as int,
      imgUrl: fields[2] as String,
      name: fields[3] as String,
      file: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ThemeDTOLocal obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.imgUrl)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.file);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeDTOLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
