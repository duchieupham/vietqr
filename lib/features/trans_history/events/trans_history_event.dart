import 'package:equatable/equatable.dart';
import 'package:vierqr/models/transaction_input_dto.dart';

class TransHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionEventGetList extends TransHistoryEvent {
  final TransactionInputDTO dto;
  final bool isLoading;

  TransactionEventGetList(this.dto, {this.isLoading = true});

  @override
  List<Object?> get props => [dto, isLoading];
}

class TransactionEventIsOwnerGetList extends TransHistoryEvent {
  final TransactionInputDTO dto;
  final bool isLoading;

  TransactionEventIsOwnerGetList(this.dto, {this.isLoading = true});

  @override
  List<Object?> get props => [dto, isLoading];
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

class TransactionEventFetchIsOwner extends TransHistoryEvent {
  final TransactionInputDTO dto;

  TransactionEventFetchIsOwner(this.dto);

  @override
  List<Object?> get props => [dto];
}

class TransactionStatusEventFetch extends TransHistoryEvent {
  final TransactionInputDTO dto;

  TransactionStatusEventFetch(this.dto);

  @override
  List<Object?> get props => [dto];
}

class GetMyListGroupEvent extends TransHistoryEvent {
  final String userID;
  final String bankId;
  final int offset;

  GetMyListGroupEvent({
    this.userID = '',
    this.bankId = '',
    this.offset = 0,
  });

  @override
  List<Object?> get props => [userID, bankId, offset];
}
