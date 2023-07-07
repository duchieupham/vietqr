import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_account_remove_dto.dart';

class BankDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BankCardGetDetailEvent extends BankDetailEvent {
  final String bankId;

  BankCardGetDetailEvent({required this.bankId});

  @override
  List<Object?> get props => [bankId];
}

class BankCardEventRemove extends BankDetailEvent {
  final BankAccountRemoveDTO dto;

  BankCardEventRemove({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankUpdateState extends BankDetailEvent {}
