import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/qr_create_dto.dart';

enum UpdateBankType {
  DELETE,
  UPDATE,
  CALL_API,
}

class BankEvent extends Equatable {
  const BankEvent();

  @override
  List<Object?> get props => [];
}

class BankCardEventGetList extends BankEvent {}

class QREventGenerateList extends BankEvent {
  final List<QRCreateDTO> list;

  const QREventGenerateList({required this.list});

  @override
  List<Object?> get props => [list];
}

class UpdateEvent extends BankEvent {}

class UpdateListBank extends BankEvent {
  final BankAccountDTO dto;
  final UpdateBankType type; // 0: edit; 1: delete

  UpdateListBank(this.dto, this.type);

  @override
  List<Object?> get props => [dto];
}

class LoadDataBankEvent extends BankEvent {}
