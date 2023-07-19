import 'package:equatable/equatable.dart';
import 'package:vierqr/models/branch_filter_dto.dart';
import 'package:vierqr/models/branch_filter_insert_dto.dart';
import 'package:vierqr/models/transaction_branch_input_dto.dart';

class BusinessTransEvent extends Equatable {
  const BusinessTransEvent();

  @override
  List<Object?> get props => [];
}

class TransactionEventGetListBranch extends BusinessTransEvent {
  final TransactionBranchInputDTO dto;

  const TransactionEventGetListBranch({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class TransactionEventFetchBranch extends BusinessTransEvent {
  final TransactionBranchInputDTO dto;

  const TransactionEventFetchBranch({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class BranchEventGetFilter extends BusinessTransEvent {
  final BranchFilterInsertDTO dto;

  const BranchEventGetFilter({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}
