import 'package:equatable/equatable.dart';
import 'package:vierqr/models/transaction_branch_input_dto.dart';
import 'package:vierqr/models/transaction_input_dto.dart';

class TransHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionEventGetListBranch extends TransHistoryEvent {
  final TransactionBranchInputDTO dto;

  TransactionEventGetListBranch({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class TransactionEventGetList extends TransHistoryEvent {
  final TransactionInputDTO dto;

  TransactionEventGetList(this.dto);

  @override
  List<Object?> get props => [dto];
}

class TransactionStatusEventGetList extends TransHistoryEvent {
  final TransactionInputDTO dto;

  TransactionStatusEventGetList(this.dto);

  @override
  List<Object?> get props => [dto];
}

class TransactionEventFetch extends TransHistoryEvent {
  final TransactionInputDTO dto;

  TransactionEventFetch(this.dto);

  @override
  List<Object?> get props => [dto];
}

class TransactionStatusEventFetch extends TransHistoryEvent {
  final TransactionInputDTO dto;

  TransactionStatusEventFetch(this.dto);

  @override
  List<Object?> get props => [dto];
}

