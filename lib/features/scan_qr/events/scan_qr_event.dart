import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_name_search_dto.dart';

class ScanQrEvent extends Equatable {
  const ScanQrEvent();

  @override
  List<Object?> get props => [];
}

class ScanQrEventGetBankType extends ScanQrEvent {
  final String code;

  const ScanQrEventGetBankType({required this.code});

  @override
  List<Object?> get props => [code];
}

class ScanQrEventSearchName extends ScanQrEvent {
  final BankNameSearchDTO dto;

  const ScanQrEventSearchName({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class PermissionEventRequest extends ScanQrEvent {
  const PermissionEventRequest();

  @override
  List<Object?> get props => [];
}

class PermissionEventGetStatus extends ScanQrEvent {
  const PermissionEventGetStatus();

  @override
  List<Object?> get props => [];
}
