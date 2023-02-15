import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_member_dto.dart';

class BankMemberState extends Equatable {
  const BankMemberState();

  @override
  List<Object?> get props => [];
}

class BankMemberInitialState extends BankMemberState {}

class BankMemberLoadingState extends BankMemberState {}

class BankMemberGetListSuccessfulState extends BankMemberState {
  final List<BankMemberDTO> list;

  const BankMemberGetListSuccessfulState({required this.list});

  @override
  List<Object?> get props => [list];
}

class BankMemberGetListFailedState extends BankMemberState {}

class BankMemberCheckSuccessfulState extends BankMemberState {
  final BankMemberDTO dto;

  const BankMemberCheckSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankMemberCheckNotExistedState extends BankMemberState {}

class BankMemberCheckAddedBeforeState extends BankMemberState {}

class BankMemberCheckFailedState extends BankMemberState {
  final String message;

  const BankMemberCheckFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

class BankMemberInsertSuccessfulState extends BankMemberState {}

class BankMemberInsertFailedState extends BankMemberState {
  final String message;

  const BankMemberInsertFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

class BankMemberRemoveSuccessfulState extends BankMemberState {}

class BankMemberRemoveFailedState extends BankMemberState {
  final String message;

  const BankMemberRemoveFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}
