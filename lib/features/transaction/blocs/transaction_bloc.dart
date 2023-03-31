import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/transaction/events/transaction_event.dart';
import 'package:vierqr/features/transaction/repositories/transaction_repository.dart';
import 'package:vierqr/features/transaction/states/transaction_state.dart';
import 'package:vierqr/models/business_detail_dto.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitialState()) {
    on<TransactionEventGetListBranch>(_getTransactions);
    on<TransactionEventFetchBranch>(_fetchTransactions);
  }
}

const TransactionRepository transactionRepository = TransactionRepository();

void _getTransactions(TransactionEvent event, Emitter emit) async {
  try {
    if (event is TransactionEventGetListBranch) {
      emit(TransactionLoadingState());
      List<BusinessTransactionDTO> result =
          await transactionRepository.getTransactionByBranchId(event.dto);
      emit(TransactionGetListBranchSuccessState(list: result));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(TransactionGetListBranchFailedState());
  }
}

void _fetchTransactions(TransactionEvent event, Emitter emit) async {
  try {
    if (event is TransactionEventFetchBranch) {
      emit(TransactionLoadingFetchState());
      List<BusinessTransactionDTO> result =
          await transactionRepository.getTransactionByBranchId(event.dto);
      emit(TransactionFetchSuccessState(list: result));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(TransactionGetListBranchFailedState());
  }
}
