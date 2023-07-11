import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_name_search_dto.dart';

class AddBankEvent extends Equatable {
  const AddBankEvent();

  @override
  List<Object?> get props => [];
}

class LoadDataBankEvent extends AddBankEvent {}

class ChooseBankEvent extends AddBankEvent {
  final int index;

  const ChooseBankEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class ChangeAccountBankEvent extends AddBankEvent {
  final String value;

  const ChangeAccountBankEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class ChangeNameEvent extends AddBankEvent {
  final String value;

  const ChangeNameEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class BankCardEventSearchName extends AddBankEvent {
  final BankNameSearchDTO dto;

  const BankCardEventSearchName({required this.dto});

  @override
  List<Object?> get props => [dto];
}
