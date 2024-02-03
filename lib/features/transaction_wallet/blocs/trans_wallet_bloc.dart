import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/transaction_wallet/repo/transaction_wallet_repo.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import '../../../models/trans_wallet_dto.dart';
import '../events/trans_wallet_event.dart';
import '../states/trans_wallet_state.dart';

class TransWalletBloc extends Bloc<TransWalletEvent, TransWalletState>
    with BaseManager {
  @override
  final BuildContext context;

  TransWalletBloc(this.context) : super(const TransWalletState(list: [])) {
    on<TransactionWalletEventGetList>(_getTransactions);
    on<TransactionWalletEventFetch>(_fetchTransactions);
  }
  TransactionWalletRepository transactionWalletRepository =
      TransactionWalletRepository();

  void _getTransactions(TransWalletEvent event, Emitter emit) async {
    try {
      if (event is TransactionWalletEventGetList) {
        bool isLoadMore = false;
        Map<String, dynamic> param = {};
        param['userId'] = UserHelper.instance.getUserId();
        param['status'] = event.status;
        param['offset'] = 0;
        emit(state.copyWith(status: BlocStatus.LOADING));
        final List<TransWalletDto> result =
            await transactionWalletRepository.getTrans(param);

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

  void _fetchTransactions(TransWalletEvent event, Emitter emit) async {
    try {
      if (event is TransactionWalletEventFetch) {
        bool isLoadMore = false;
        int offset = state.offset;
        offset += 1;
        Map<String, dynamic> param = {};
        param['userId'] = UserHelper.instance.getUserId();
        param['status'] = event.status;
        param['offset'] = offset * 20;
        List<TransWalletDto> data = state.list;
        emit(state.copyWith(
            status: BlocStatus.NONE, type: TransHistoryType.NONE));
        final List<TransWalletDto> result =
            await transactionWalletRepository.getTrans(param);
        if (result.isEmpty || result.length < 20) {
          isLoadMore = true;
        }
        data.addAll(result);
        emit(state.copyWith(
          list: data,
          type: TransHistoryType.LOAD_DATA,
          isLoadMore: isLoadMore,
          offset: offset,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(type: TransHistoryType.ERROR));
    }
  }
}
