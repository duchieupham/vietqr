import 'package:equatable/equatable.dart';
import 'package:vierqr/models/business_detail_dto.dart';

class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitialState extends TransactionState {}

class TransactionLoadingState extends TransactionState {}

class TransactionGetListBranchSuccessState extends TransactionState {
  final List<BusinessTransactionDTO> list;

  const TransactionGetListBranchSuccessState({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}

class TransactionGetListBranchFailedState extends TransactionState {}

class TransactionLoadingFetchState extends TransactionState {}

class TransactionFetchSuccessState extends TransactionState {
  final List<BusinessTransactionDTO> list;

  const TransactionFetchSuccessState({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}
