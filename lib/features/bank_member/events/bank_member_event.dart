import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_member_insert_dto.dart';

class BankMemberEvent extends Equatable {
  const BankMemberEvent();

  @override
  List<Object?> get props => [];
}

class BankMemberEventGetList extends BankMemberEvent {
  final String bankId;

  const BankMemberEventGetList({required this.bankId});

  @override
  List<Object?> get props => [bankId];
}

class BankMemberEventCheck extends BankMemberEvent {
  final BankMemberInsertDTO dto;

  const BankMemberEventCheck({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankMemberEventInsert extends BankMemberEvent {
  final BankMemberInsertDTO dto;

  const BankMemberEventInsert({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankMemberInitialEvent extends BankMemberEvent {}

class BankMemberRemoveEvent extends BankMemberEvent {
  final String id;

  const BankMemberRemoveEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
