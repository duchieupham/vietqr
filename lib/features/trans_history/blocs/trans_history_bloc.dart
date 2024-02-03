import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/trans_history/events/trans_history_event.dart';
import 'package:vierqr/features/trans_history/states/trans_history_state.dart';
import 'package:vierqr/features/transaction/blocs/transaction_bloc.dart';
import 'package:vierqr/models/related_transaction_receive_dto.dart';

class TransHistoryBloc extends Bloc<TransHistoryEvent, TransHistoryState>
    with BaseManager {
  @override
  final BuildContext context;

  final String bankId;

  TransHistoryBloc(this.context, this.bankId)
      : super(const TransHistoryState(list: [])) {
    // on<TransactionEventGetDetail>(_getDetail);
    // on<TransactionEventGetImage>(_loadImage);
    // on<TransEventQRRegenerate>(_regenerateQR);
    on<TransactionStatusEventGetList>(_getTransactionsStatus);
    on<TransactionStatusEventFetch>(_fetchTransactionsStatus);
    on<TransactionEventGetList>(_getTransactions);
    on<TransactionEventFetch>(_fetchTransactions);
  }

  void _getTransactionsStatus(TransHistoryEvent event, Emitter emit) async {
    try {
      if (event is TransactionStatusEventGetList) {
        bool isLoadMore = false;
        emit(state.copyWith(status: BlocStatus.LOADING));
        final List<RelatedTransactionReceiveDTO> result =
            await transactionRepository.getTransStatus(event.dto);
        if (result.isEmpty || result.length < 20) {
          isLoadMore = true;
        }
        emit(
          state.copyWith(
            list: result,
            type: TransHistoryType.LOAD_DATA,
            status: BlocStatus.UNLOADING,
            isLoadMore: isLoadMore,
            offset: 0,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(type: TransHistoryType.ERROR));
    }
  }

  void _getTransactions(TransHistoryEvent event, Emitter emit) async {
    try {
      if (event is TransactionEventGetList) {
        bool isLoadMore = false;
        emit(state.copyWith(status: BlocStatus.LOADING));
        final List<RelatedTransactionReceiveDTO> result =
            await transactionRepository.getTrans(event.dto);
        if (result.isEmpty || result.length < 20) {
          isLoadMore = true;
        }
        emit(
          state.copyWith(
            list: result,
            type: TransHistoryType.LOAD_DATA,
            status: BlocStatus.UNLOADING,
            isLoadMore: isLoadMore,
            offset: 0,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(type: TransHistoryType.ERROR));
    }
  }

  void _fetchTransactions(TransHistoryEvent event, Emitter emit) async {
    try {
      if (event is TransactionEventFetch) {
        bool isLoadMore = false;
        List<RelatedTransactionReceiveDTO> data = state.list;
        emit(state.copyWith(
            status: BlocStatus.NONE, type: TransHistoryType.NONE));
        final List<RelatedTransactionReceiveDTO> result =
            await transactionRepository.getTrans(event.dto);
        if (result.isEmpty || result.length < 20) {
          isLoadMore = true;
        }
        data.addAll(result);
        emit(state.copyWith(
          list: data,
          type: TransHistoryType.LOAD_DATA,
          isLoadMore: isLoadMore,
          offset: event.dto.offset,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(type: TransHistoryType.ERROR));
    }
  }

  void _fetchTransactionsStatus(TransHistoryEvent event, Emitter emit) async {
    try {
      if (event is TransactionStatusEventFetch) {
        bool isLoadMore = false;
        List<RelatedTransactionReceiveDTO> data = state.list;
        emit(state.copyWith(
            status: BlocStatus.NONE, type: TransHistoryType.NONE));
        final List<RelatedTransactionReceiveDTO> result =
            await transactionRepository.getTransStatus(event.dto);
        if (result.isEmpty || result.length < 20) {
          isLoadMore = true;
        }
        data.addAll(result);
        emit(state.copyWith(
          list: data,
          type: TransHistoryType.LOAD_DATA,
          isLoadMore: isLoadMore,
          offset: event.dto.offset,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(type: TransHistoryType.ERROR));
    }
  }
}
