// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemeDTOAdapter extends TypeAdapter<ThemeDTO> {
  @override
  final int typeId = 1;

  @override
  ThemeDTO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemeDTO(
      id: fields[0] as String,
      type: fields[1] as int,
      imgUrl: fields[2] as String,
      name: fields[3] as String,
      photoPath: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ThemeDTO obj) {
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
      ..write(obj.photoPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeDTOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
