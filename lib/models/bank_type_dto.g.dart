// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_type_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BankTypeDTOAdapter extends TypeAdapter<BankTypeDTO> {
  @override
  final int typeId = 2;

  @override
  BankTypeDTO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BankTypeDTO(
      id: fields[1] as String,
      bankCode: fields[2] as String,
      bankName: fields[3] as String,
      bankShortName: fields[4] as String?,
      imageId: fields[5] as String,
      status: fields[6] as int,
      caiValue: fields[7] as String,
      fileImage: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BankTypeDTO obj) {
    writer
      ..writeByte(8)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.bankCode)
      ..writeByte(3)
      ..write(obj.bankName)
      ..writeByte(4)
      ..write(obj.bankShortName)
      ..writeByte(5)
      ..write(obj.imageId)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.caiValue)
      ..writeByte(8)
      ..write(obj.fileImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankTypeDTOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
