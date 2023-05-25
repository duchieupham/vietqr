import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/transaction/events/transaction_event.dart';
import 'package:vierqr/features/transaction/repositories/transaction_repository.dart';
import 'package:vierqr/features/transaction/states/transaction_state.dart';
import 'package:vierqr/models/business_detail_dto.dart';
import 'package:vierqr/models/related_transaction_receive_dto.dart';
import 'package:vierqr/models/transaction_receive_dto.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitialState()) {
    on<TransactionEventGetListBranch>(_getTransactionsBranch);
    on<TransactionEventFetchBranch>(_fetchTransactionsBranch);
    on<TransactionEventGetList>(_getTransactions);
    on<TransactionEventFetch>(_fetchTransactions);
    on<TransactionEventGetDetail>(_getDetail);
  }
}

const TransactionRepository transactionRepository = TransactionRepository();

void _getTransactionsBranch(TransactionEvent event, Emitter emit) async {
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

void _fetchTransactionsBranch(TransactionEvent event, Emitter emit) async {
  try {
    if (event is TransactionEventFetchBranch) {
      emit(TransactionLoadingFetchState());
      List<BusinessTransactionDTO> result =
          await transactionRepository.getTransactionByBranchId(event.dto);
      emit(TransactionFetchBranchSuccessState(list: result));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(TransactionGetListBranchFailedState());
  }
}

void _getTransactions(TransactionEvent event, Emitter emit) async {
  try {
    if (event is TransactionEventGetList) {
      emit(TransactionLoadingState());
      final List<RelatedTransactionReceiveDTO> result =
          await transactionRepository.getTransactionByBankId(event.dto);
      emit(TransactionGetListSuccessState(list: result));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(TransactionGetListFailedState());
  }
}

void _fetchTransactions(TransactionEvent event, Emitter emit) async {
  try {
    if (event is TransactionEventFetch) {
      emit(TransactionLoadingState());
      final List<RelatedTransactionReceiveDTO> result =
          await transactionRepository.getTransactionByBankId(event.dto);
      emit(TransactionFetchSuccessState(list: result));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(TransactionFetchFailedState());
  }
}

void _getDetail(TransactionEvent event, Emitter emit) async {
  try {
    if (event is TransactionEventGetDetail) {
      emit(TransactionDetailLoadingState());
      TransactionReceiveDTO dto =
          await transactionRepository.getTransactionDetail(event.id);
      emit(TransactionDetailSuccessState(dto: dto));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(TransactionDetailFailedState());
  }
}
