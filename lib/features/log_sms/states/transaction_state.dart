import 'package:equatable/equatable.dart';
import 'package:vierqr/models/transaction_dto.dart';

class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitialState extends TransactionState {
  const TransactionInitialState();

  @override
  List<Object?> get props => [];
}

//For event insert
class TransactionInsertSuccessState extends TransactionState {
  final String bankId;
  final String transactionId;
  final dynamic timeInserted;
  final String address;
  final String transaction;

  const TransactionInsertSuccessState(
      {required this.bankId,
      required this.transactionId,
      required this.timeInserted,
      required this.address,
      required this.transaction});

  @override
  List<Object?> get props => [
        bankId,
        transactionId,
        timeInserted,
        address,
        transaction,
      ];
}

class TransactionInsertFailedState extends TransactionState {
  const TransactionInsertFailedState();

  @override
  List<Object?> get props => [];
}

//for event get list
class TransactionLoadingListState extends TransactionState {
  const TransactionLoadingListState();

  @override
  List<Object?> get props => [];
}

class TransactionSuccessfulListState extends TransactionState {
  final List<TransactionDTO> list;

  const TransactionSuccessfulListState({required this.list});

  @override
  List<Object?> get props => [list];
}

class TransactionFailedListState extends TransactionState {
  const TransactionFailedListState();

  @override
  List<Object?> get props => [];
}
