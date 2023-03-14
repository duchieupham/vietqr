import 'package:equatable/equatable.dart';

class BankTextFormEvent extends Equatable {
  const BankTextFormEvent();

  @override
  List<Object?> get props => [];
}

class BankTextFormEventInsert extends BankTextFormEvent {
  final String text;
  final String bankId;

  const BankTextFormEventInsert({required this.text, required this.bankId});

  @override
  List<Object?> get props => [text, bankId];
}

class BankTextFormEventGetList extends BankTextFormEvent {
  final String bankId;

  const BankTextFormEventGetList({required this.bankId});

  @override
  List<Object?> get props => [bankId];
}

class BankTextFormEventRemove extends BankTextFormEvent {
  final String id;

  const BankTextFormEventRemove({required this.id});

  @override
  List<Object?> get props => [id];
}
