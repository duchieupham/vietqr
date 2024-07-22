import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_detail_new/repositories/transaction_repository.dart';
import 'package:vierqr/features/bank_detail_new/states/transaction_state.dart';
import 'package:vierqr/features/bank_detail_new/widgets/filter_time_widget.dart';
import 'package:vierqr/models/metadata_dto.dart';

import '../events/transaction_event.dart';

class NewTransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  NewTransactionBloc()
      : super(TransactionState(
            filter: FilterTrans(title: '7 ngày gần đây', type: 0))) {
    on<TransTimeType>(_setFilter);
    on<GetTransListEvent>(_getTransList);
  }

  MetaDataDTO? metadata;

  final TransactionRepository _repository = TransactionRepository();

  void _setFilter(TransactionEvent event, Emitter emit) {
    if (event is TransTimeType) {
      emit(state.copyWith(
        filter: event.filter,
      ));
    }
  }

  void _getTransList(TransactionEvent event, Emitter emit) async {
    try {
      if (event is GetTransListEvent) {
        if (!event.isLoadMore) {
          emit(state.copyWith(
              status: BlocStatus.LOADING,
              request: NewTranstype.GET_TRANS_LIST));
          final result = await _repository.getListTrans(
              bankId: event.bankId,
              value: event.value,
              fromDate: event.fromDate,
              toDate: event.toDate,
              type: event.type,
              page: event.page ?? 1,
              size: event.size ?? 20);
          await Future.delayed(const Duration(milliseconds: 500));
          if (result != null) {
            metadata = _repository.metaDataDTO;
            emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              request: NewTranstype.GET_TRANS_LIST,
              transItem: result.items,
              extraData: result.extraData,
              metadata: _repository.metaDataDTO,
            ));
          } else {
            emit(state.copyWith(
              status: BlocStatus.ERROR,
              request: NewTranstype.GET_TRANS_LIST,
              transItem: [],
              extraData: null,
            ));
          }
        } else {
          if (metadata != null) {
            int total = (metadata!.total! / 20).ceil();
            if (total > metadata!.page!) {
              emit(state.copyWith(
                  status: BlocStatus.LOAD_MORE,
                  request: NewTranstype.GET_TRANS_LIST));
              final result = await _repository.getListTrans(
                  bankId: event.bankId,
                  value: event.value,
                  fromDate: event.fromDate,
                  toDate: event.toDate,
                  type: event.type,
                  page: event.page ?? 1,
                  size: event.size ?? 20);
              if (result != null) {
                metadata = _repository.metaDataDTO;
                emit(state.copyWith(
                  status: BlocStatus.SUCCESS,
                  request: NewTranstype.GET_TRANS_LIST,
                  transItem: result.items,
                  extraData: result.extraData,
                  metadata: _repository.metaDataDTO,
                ));
              } else {
                emit(state.copyWith(
                  status: BlocStatus.ERROR,
                  request: NewTranstype.GET_TRANS_LIST,
                  transItem: [],
                  extraData: null,
                ));
              }
            }
          }
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        status: BlocStatus.ERROR,
        request: NewTranstype.GET_TRANS_LIST,
      ));
    }
  }
}
