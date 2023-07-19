import 'package:equatable/equatable.dart';
import 'package:vierqr/models/transaction_branch_input_dto.dart';
import 'package:vierqr/models/transaction_input_dto.dart';

class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class TransactionEventGetListBranch extends TransactionEvent {
  final TransactionBranchInputDTO dto;

  const TransactionEventGetListBranch({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class TransactionEventFetchBranch extends TransactionEvent {
  final TransactionBranchInputDTO dto;

  const TransactionEventFetchBranch({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class TransactionEventGetList extends TransactionEvent {
  final TransactionInputDTO dto;

  const TransactionEventGetList({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class TransactionEventFetch extends TransactionEvent {
  final TransactionInputDTO dto;

  const TransactionEventFetch({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class TransactionEventGetDetail extends TransactionEvent {}

class TransactionEventGetImage extends TransactionEvent {}
