import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/features/log_sms/events/transaction_event.dart';
import 'package:vierqr/features/log_sms/repositories/transaction_repository.dart';
import 'package:vierqr/features/log_sms/states/transaction_state.dart';
import 'package:vierqr/features/notification/blocs/notification_bloc.dart';
import 'package:vierqr/models/transaction_dto.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(const TransactionInitialState()) {
    on<TransactionEventInsert>(_insertTransaction);
    on<TransactionEventGetList>(_getTransactions);
  }
}

const TransactionRepository transactionRepository = TransactionRepository();

void _insertTransaction(TransactionEvent event, Emitter emit) async {
  try {
    if (event is TransactionEventInsert) {
      if (event.transactionDTO.bankId.isNotEmpty) {
        await transactionRepository.insertTransaction(event.transactionDTO);
        emit(TransactionInsertSuccessState(
          bankId: event.transactionDTO.bankId,
          transactionId: event.transactionDTO.id,
          timeInserted: event.transactionDTO.timeInserted,
          address: event.transactionDTO.address,
          transaction: event.transactionDTO.transaction,
        ));
      }
    }
  } catch (e) {
    print('Error at _insertTransaction - TransactionBloc: $e');
    emit(const TransactionInsertFailedState());
  }
}

void _getTransactions(TransactionEvent event, Emitter emit) async {
  try {
    if (event is TransactionEventGetList) {
      emit(const TransactionLoadingListState());
      //get list transactionId
      List<String> transactionIds =
          await notificationRepository.getTransactionIdsByUserId(event.userId);
      //get transaction
      List<TransactionDTO> list =
          await transactionRepository.getTransactionsByIds(transactionIds);
      emit(TransactionSuccessfulListState(list: list));
    }
  } catch (e) {
    print('Error at _getTransactions - TransactionBloc: $e');
    emit(const TransactionFailedListState());
  }
}
