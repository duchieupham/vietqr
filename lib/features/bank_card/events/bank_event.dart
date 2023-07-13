import 'package:equatable/equatable.dart';
import 'package:vierqr/models/qr_create_dto.dart';

class BankEvent extends Equatable {
  const BankEvent();

  @override
  List<Object?> get props => [];
}

class BankCardEventGetList extends BankEvent {}

class ScanQrEventGetBankType extends BankEvent {
  final String code;

  const ScanQrEventGetBankType({required this.code});

  @override
  List<Object?> get props => [code];
}

class QREventGenerateList extends BankEvent {
  final List<QRCreateDTO> list;

  const QREventGenerateList({required this.list});

  @override
  List<Object?> get props => [list];
}

class UpdateEvent extends BankEvent {}
