import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_name_search_dto.dart';

class DashBoardEvent extends Equatable {
  const DashBoardEvent();

  @override
  List<Object?> get props => [];
}

class PermissionEventRequest extends DashBoardEvent {
  const PermissionEventRequest();

  @override
  List<Object?> get props => [];
}

class PermissionEventGetStatus extends DashBoardEvent {
  const PermissionEventGetStatus();

  @override
  List<Object?> get props => [];
}

class ScanQrEventGetBankType extends DashBoardEvent {
  final String code;

  const ScanQrEventGetBankType({required this.code});

  @override
  List<Object?> get props => [code];
}

class DashBoardEventSearchName extends DashBoardEvent {
  final BankNameSearchDTO dto;

  const DashBoardEventSearchName({required this.dto});

  @override
  List<Object?> get props => [dto];
}
