import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/qr_create_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/qr_recreate_dto.dart';

class CreateQREvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class QrEventGetBankDetail extends CreateQREvent {}

class QREventGetList extends CreateQREvent {}

class QREventGetTerminals extends CreateQREvent {}

class QREventSetBankAccountDTO extends CreateQREvent {
  final BankAccountDTO dto;

  QREventSetBankAccountDTO(this.dto);

  @override
  List<Object?> get props => [dto];
}

class QREventGenerateList extends CreateQREvent {
  final List<QRCreateDTO> list;

  QREventGenerateList({required this.list});

  @override
  List<Object?> get props => [list];
}

class QREventGenerate extends CreateQREvent {
  final QRCreateDTO dto;

  QREventGenerate({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class QREventRegenerate extends CreateQREvent {
  final QRRecreateDTO dto;

  QREventRegenerate({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class QREventUploadImage extends CreateQREvent {
  final QRGeneratedDTO? dto;
  final File? file;

  QREventUploadImage({required this.dto, required this.file});

  @override
  List<Object?> get props => [dto, file];
}

class QREventPaid extends CreateQREvent {
  final String id;

  QREventPaid(this.id);

  @override
  List<Object?> get props => [id];
}

class QrEventScanGetBankType extends CreateQREvent {
  final String code;

  QrEventScanGetBankType({required this.code});

  @override
  List<Object?> get props => [code];
}
