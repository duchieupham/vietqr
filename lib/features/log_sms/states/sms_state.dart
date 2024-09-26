import 'package:equatable/equatable.dart';
import 'package:vierqr/models/message_dto.dart';
import 'package:vierqr/models/transaction_dto.dart';

class SMSState extends Equatable {
  const SMSState();

  @override
  List<Object?> get props => [];
}

class SMSInitialState extends SMSState {}

class SMSLoadingListState extends SMSState {}

//for get list
class SMSSuccessfulListState extends SMSState {
  final Map<String, List<MessageDTO>> messages;

  const SMSSuccessfulListState({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class SMSFailedListState extends SMSState {
  const SMSFailedListState();

  @override
  List<Object?> get props => [];
}

//for listen new SMS
class SMSListenFailedState extends SMSState {
  const SMSListenFailedState();

  @override
  List<Object?> get props => [];
}

//for receive new SMS
class SMSReceivedState extends SMSState {
  final MessageDTO messageDTO;
  final TransactionDTO transactionDTO;

  const SMSReceivedState({
    required this.messageDTO,
    required this.transactionDTO,
  });

  @override
  List<Object?> get props => [messageDTO, transactionDTO];
}

class SMSReceivedFailedState extends SMSState {
  const SMSReceivedFailedState();

  @override
  List<Object?> get props => [];
}
