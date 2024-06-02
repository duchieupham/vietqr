import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/trans_history/events/trans_history_event.dart';
import 'package:vierqr/features/trans_history/states/trans_history_state.dart';
import 'package:vierqr/features/transaction_detail/repositories/transaction_repository.dart';
import 'package:vierqr/models/terminal_response_dto.dart';
import 'package:vierqr/models/trans_dto.dart';

class TransHistoryBloc extends Bloc<TransHistoryEvent, TransHistoryState>
    with BaseManager {
  @override
  final BuildContext context;

  final String bankId;

  // final TerminalDto terminalDto;
  final List<TerminalAccountDTO> terminalAccountList;

  final TransactionRepository transactionRepository;

  TransHistoryBloc(this.context, this.transactionRepository, this.bankId,
      this.terminalAccountList)
      : super(TransHistoryState(
            list: [],
            // terminalDto: terminalDto,
            terminalAccountList: terminalAccountList)) {
    // on<TransactionEventGetDetail>(_getDetail);
    // on<TransactionEventGetImage>(_loadImage);
    // on<TransEventQRRegenerate>(_regenerateQR);
    on<TransactionStatusEventGetList>(_getTransactionsStatus);
    on<TransactionEventIsOwnerGetList>(_getTransactionsIsOwner);
    on<TransactionStatusEventFetch>(_fetchTransactionsStatus);
    on<TransactionEventFetchIsOwner>(_fetchTransactionsIsOwner);
    on<TransactionEventGetList>(_getTransactions);
    on<TransactionEventFetch>(_fetchTransactions);
    on<GetMyListGroupEvent>(_getMyListGroupTrans);
  }

  void _getTransactionsStatus(TransHistoryEvent event, Emitter emit) async {
    try {
      if (event is TransactionStatusEventGetList) {
        bool isLoadMore = true;
        emit(state.copyWith(status: BlocStatus.LOADING));
        final List<TransDTO> result =
            await transactionRepository.getTransStatus(event.dto);
        if (result.isEmpty || result.length < 20) {
          isLoadMore = false;
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
        bool isLoadMore = true;
        emit(state.copyWith(
            status: event.isLoading ? BlocStatus.LOADING : BlocStatus.NONE));
        final List<TransDTO> result =
            await transactionRepository.getTrans(event.dto);
        if (result.isEmpty || result.length < 20) {
          isLoadMore = false;
        }
        emit(
          state.copyWith(
            list: result,
            type: TransHistoryType.LOAD_DATA,
            status: BlocStatus.UNLOADING,
            isLoadMore: isLoadMore,
            offset: 0,
            isEmpty: result.isEmpty,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(type: TransHistoryType.ERROR));
    }
  }

  void _getTransactionsIsOwner(TransHistoryEvent event, Emitter emit) async {
    try {
      if (event is TransactionEventIsOwnerGetList) {
        bool isLoadMore = true;
        emit(state.copyWith(
            status: event.isLoading ? BlocStatus.LOADING : BlocStatus.NONE));
        final List<TransDTO> result =
            await transactionRepository.getTransIsOwner(event.dto);
        if (result.isEmpty || result.length < 20) {
          isLoadMore = false;
        }
        emit(
          state.copyWith(
            list: result,
            type: TransHistoryType.LOAD_DATA,
            status: BlocStatus.UNLOADING,
            isLoadMore: isLoadMore,
            offset: 0,
            isEmpty: result.isEmpty,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(type: TransHistoryType.ERROR));
    }
  }

  void _fetchTransactionsIsOwner(TransHistoryEvent event, Emitter emit) async {
    try {
      if (event is TransactionEventFetchIsOwner) {
        bool isLoadMore = true;
        List<TransDTO> data = state.list;
        emit(state.copyWith(
            status: BlocStatus.NONE, type: TransHistoryType.NONE));
        final List<TransDTO> result =
            await transactionRepository.getTransIsOwner(event.dto);
        if (result.isEmpty || result.length < 20) {
          isLoadMore = false;
        }
        data.addAll(result);
        emit(
          state.copyWith(
            list: data,
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
        bool isLoadMore = true;
        List<TransDTO> data = state.list;
        emit(state.copyWith(
            status: BlocStatus.NONE, type: TransHistoryType.NONE));
        final List<TransDTO> result =
            await transactionRepository.getTrans(event.dto);
        if (result.isEmpty || result.length < 20) {
          isLoadMore = false;
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
        bool isLoadMore = true;
        List<TransDTO> data = state.list;
        emit(state.copyWith(
            status: BlocStatus.NONE, type: TransHistoryType.NONE));
        final List<TransDTO> result =
            await transactionRepository.getTransStatus(event.dto);
        if (result.isEmpty || result.length < 20) {
          isLoadMore = false;
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

  // void _getMyListGroup(TransHistoryEvent event, Emitter emit) async {
  //   try {
  //     if (event is GetMyListGroupEvent) {
  //       emit(state.copyWith(
  //           status: BlocStatus.NONE, type: TransHistoryType.NONE));

  //       final TerminalDto terminalDto = await transactionRepository
  //           .getMyListGroup(event.userID, event.bankId, event.offset);
  //       emit(state.copyWith(
  //         status: BlocStatus.NONE,
  //         terminalDto: terminalDto,
  //         type: TransHistoryType.GET_LIST_GROUP,
  //       ));
  //     }
  //   } catch (e) {
  //     LOG.error(e.toString());
  //     emit(state.copyWith(status: BlocStatus.NONE));
  //   }
  // }

  void _getMyListGroupTrans(TransHistoryEvent event, Emitter emit) async {
    try {
      if (event is GetMyListGroupEvent) {
        emit(state.copyWith(
            status: BlocStatus.NONE, type: TransHistoryType.NONE));

        final List<TerminalAccountDTO>? terminaAccountlDto =
            await transactionRepository.getMyListGroupTrans(
                event.userID, event.bankId, event.offset);
        emit(state.copyWith(
          status: BlocStatus.NONE,
          terminalAccountDto: terminaAccountlDto,
          type: TransHistoryType.GET_LIST_GROUP,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.NONE));
    }
  }
}
