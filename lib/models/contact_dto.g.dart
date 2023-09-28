// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactDTOAdapter extends TypeAdapter<ContactDTO> {
  @override
  final int typeId = 0;

  @override
  ContactDTO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactDTO(
      id: fields[0] as String,
      nickname: fields[1] as String,
      status: fields[2] as int,
      type: fields[3] as int,
      imgId: fields[4] as String,
      description: fields[5] as String,
      phoneNo: fields[6] as String,
      carrierTypeId: fields[7] as String,
      relation: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ContactDTO obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nickname)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.imgId)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.phoneNo)
      ..writeByte(7)
      ..write(obj.carrierTypeId)
      ..writeByte(8)
      ..write(obj.relation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactDTOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
