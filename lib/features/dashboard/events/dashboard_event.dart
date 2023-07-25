import 'package:equatable/equatable.dart';
import 'package:vierqr/models/add_contact_dto.dart';
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

class DashBoardEventAddContact extends DashBoardEvent {
  final AddContactDTO dto;

  const DashBoardEventAddContact({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class DashBoardCheckExistedEvent extends DashBoardEvent {
  final String bankAccount;
  final String bankTypeId;

  const DashBoardCheckExistedEvent({
    required this.bankAccount,
    required this.bankTypeId,
  });

  @override
  List<Object?> get props => [bankAccount, bankTypeId];
}

class DashBoardEventInsertUnauthenticated extends DashBoardEvent {
  final BankCardInsertUnauthenticatedDTO dto;

  const DashBoardEventInsertUnauthenticated({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class UpdateEvent extends DashBoardEvent {}
