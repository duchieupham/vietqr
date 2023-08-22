import 'package:equatable/equatable.dart';
import 'package:vierqr/models/transaction_branch_input_dto.dart';

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
  final int status;

  TransactionEventGetList(this.status);

  @override
  List<Object?> get props => [status];
}

class TransactionEventFetch extends TransHistoryEvent {
  final int status;

  TransactionEventFetch(this.status);

  @override
  List<Object?> get props => [status];
}
