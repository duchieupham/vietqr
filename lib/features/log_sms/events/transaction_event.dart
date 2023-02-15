import 'package:equatable/equatable.dart';
import 'package:vierqr/models/transaction_dto.dart';

class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class TransactionEventInsert extends TransactionEvent {
  final TransactionDTO transactionDTO;

  const TransactionEventInsert({
    required this.transactionDTO,
  });

  @override
  List<Object?> get props => [transactionDTO];
}

class TransactionEventGetList extends TransactionEvent {
  final String userId;

  const TransactionEventGetList({required this.userId});

  @override
  List<Object?> get props => [userId];
}
