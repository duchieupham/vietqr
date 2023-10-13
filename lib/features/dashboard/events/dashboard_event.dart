import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_card_insert_unauthenticated.dart';
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

class DashBoardEventInsertUnauthenticated extends DashBoardEvent {
  final BankCardInsertUnauthenticatedDTO dto;

  const DashBoardEventInsertUnauthenticated({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class UpdateEvent extends DashBoardEvent {}

class GetPointEvent extends DashBoardEvent {}

class GetVersionAppEvent extends DashBoardEvent {
  final bool isCheckVer;

  GetVersionAppEvent({this.isCheckVer = false});

  @override
  List<Object?> get props => [isCheckVer];
}

class TokenEventCheckValid extends DashBoardEvent {
  const TokenEventCheckValid();

  @override
  List<Object?> get props => [];
}

class TokenFcmUpdateEvent extends DashBoardEvent {
  const TokenFcmUpdateEvent();

  @override
  List<Object?> get props => [];
}

class TokenEventLogout extends DashBoardEvent {}

class GetUserInformation extends DashBoardEvent {}
