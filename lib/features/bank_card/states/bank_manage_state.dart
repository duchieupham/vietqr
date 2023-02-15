import 'package:vierqr/models/account_balance_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:equatable/equatable.dart';

class BankManageState extends Equatable {
  const BankManageState();
  @override
  List<Object?> get props => [];
}

class BankManageInitialState extends BankManageState {
  @override
  List<Object?> get props => [];
}

class BankManageLoadingState extends BankManageState {
  @override
  List<Object?> get props => [];
}

class BankManageLoadingListState extends BankManageState {}

class BankManageListSuccessState extends BankManageState {
  final List<BankAccountDTO> list;
  const BankManageListSuccessState({required this.list});

  @override
  List<Object?> get props => [list];
}

class BankManageListFailedState extends BankManageState {}

class BankManageAddSuccessState extends BankManageState {}

class BankManageAddFailedState extends BankManageState {}

class BankManageRemoveSuccessState extends BankManageState {}

class BankManageRemoveFailedState extends BankManageState {}

class BankManageGetDTOSuccessfulState extends BankManageState {
  final BankAccountDTO bankAccountDTO;

  const BankManageGetDTOSuccessfulState({required this.bankAccountDTO});

  @override
  List<Object?> get props => [bankAccountDTO];
}

class BankManageGetDTOFailedState extends BankManageState {}

class BankManageGetAccountBalanceSuccessState extends BankManageState {
  final AccountBalanceDTO accountBalanceDTO;

  const BankManageGetAccountBalanceSuccessState(
      {required this.accountBalanceDTO});

  @override
  List<Object?> get props => [accountBalanceDTO];
}

class BankManageGetAccountBalanceFailedState extends BankManageState {}
