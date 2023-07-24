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

class TransactionEventGetList extends TransHistoryEvent {}

class TransactionEventFetch extends TransHistoryEvent {}
