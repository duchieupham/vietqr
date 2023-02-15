import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class BankTypeState extends Equatable {
  const BankTypeState();

  @override
  List<Object?> get props => [];
}

class BankTypeInitialState extends BankTypeState {}

class BankTypeLoadingState extends BankTypeState {}

class BankTypeGetListSuccessfulState extends BankTypeState {
  final List<BankTypeDTO> list;

  const BankTypeGetListSuccessfulState({required this.list});

  @override
  List<Object?> get props => [list];
}

class BankTypeGetListFailedState extends BankTypeState {}

class BankTypeSearchState extends BankTypeState {
  final List<BankTypeDTO> list;

  const BankTypeSearchState({required this.list});

  @override
  List<Object?> get props => [list];
}
