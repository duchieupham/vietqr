// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_detail_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactDetailDTOAdapter extends TypeAdapter<ContactDetailDTO> {
  @override
  final int typeId = 1;

  @override
  ContactDetailDTO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactDetailDTO(
      id: fields[0] as String?,
      userId: fields[1] as String?,
      additionalData: fields[2] as String?,
      nickName: fields[3] as String?,
      email: fields[4] as String?,
      type: fields[5] as int?,
      status: fields[6] as int?,
      value: fields[7] as String?,
      bankShortName: fields[8] as String?,
      bankName: fields[9] as String?,
      imgId: fields[10] as String?,
      bankAccount: fields[11] as String?,
      colorType: fields[12] as int,
      relation: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ContactDetailDTO obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.additionalData)
      ..writeByte(3)
      ..write(obj.nickName)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.value)
      ..writeByte(8)
      ..write(obj.bankShortName)
      ..writeByte(9)
      ..write(obj.bankName)
      ..writeByte(10)
      ..write(obj.imgId)
      ..writeByte(11)
      ..write(obj.bankAccount)
      ..writeByte(12)
      ..write(obj.colorType)
      ..writeByte(13)
      ..write(obj.relation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactDetailDTOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
