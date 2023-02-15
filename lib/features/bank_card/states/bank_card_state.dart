import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_account_dto.dart';

class BankCardState extends Equatable {
  const BankCardState();

  @override
  List<Object?> get props => [];
}

class BankCardInitialState extends BankCardState {}

class BankCardLoadingState extends BankCardState {}

class BankCardInsertSuccessfulState extends BankCardState {}

class BankCardInsertFailedState extends BankCardState {
  final String message;

  const BankCardInsertFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

class BankCardGetListSuccessState extends BankCardState {
  final List<BankAccountDTO> list;

  const BankCardGetListSuccessState({required this.list});

  @override
  List<Object?> get props => [list];
}

class BankCardGetListFailedState extends BankCardState {
  final String message;

  const BankCardGetListFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

class BankCardRemoveSuccessState extends BankCardState {}

class BankCardRemoveFailedState extends BankCardState {
  final String message;

  const BankCardRemoveFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}
