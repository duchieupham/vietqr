import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_detail_new/repositories/transaction_repository.dart';
import 'package:vierqr/features/bank_detail_new/states/transaction_state.dart';
import 'package:vierqr/features/bank_detail_new/widgets/filter_time_widget.dart';
import 'package:vierqr/models/metadata_dto.dart';
import 'package:vierqr/models/trans_list_dto.dart';

import '../events/transaction_event.dart';

class NewTransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  NewTransactionBloc()
      : super(TransactionState(
            filter: FilterTrans(title: '7 ngày gần đây', type: 0))) {
    on<SetTransTimeType>(_setFilter);
    on<SetTransType>(_setType);
    on<SetTransValue>(_setValue);
    on<GetTransListEvent>(_getTransList);
    on<GetTransDetailEvent>(_getTransDetail);
  }

  int offset = 0;
  String value = '';
  int transType = 9;
  FilterTrans filterTime = FilterTrans(
      title: '7 ngày gần đây',
      type: 0,
      fromDate:
          '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 7)))} 00:00:00',
      toDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59');

  final TransactionRepository _repository = TransactionRepository();

  void _setFilter(TransactionEvent event, Emitter emit) {
    if (event is SetTransTimeType) {
      emit(state.copyWith(
        filter: event.filter,
      ));
      filterTime = event.filter;
    }
  }

  void _setType(TransactionEvent event, Emitter emit) {
    if (event is SetTransType) {
      transType = event.type;
    }
  }

  void _setValue(TransactionEvent event, Emitter emit) {
    if (event is SetTransValue) {
      value = event.value;
    }
  }

  // void _getTransLog(TransactionEvent event, Emitter emit) async {
  //   try {
  //     if (event is GetTransLOGEvent) {
  //       // emit(state.copyWith(
  //       //     status: BlocStatus.NONE, requestDetail: TransDetail.LOG));

  //       emit(state.copyWith(
  //           // status: BlocStatus.SUCCESS,
  //           // requestDetail: TransDetail.LOG,
  //           transLogList: result));
  //     }
  //   } catch (e) {
  //     LOG.error(e.toString());
  //     emit(state.copyWith(
  //         status: BlocStatus.ERROR, requestDetail: TransDetail.LOG));
  //   }
  // }

  void _getTransDetail(TransactionEvent event, Emitter emit) async {
    try {
      if (event is GetTransDetailEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING_PAGE,
            requestDetail: TransDetail.GET_DETAIL));

        final result = await _repository.getTransDetail(event.id);

        final resultLog = await _repository.getTransLog(event.id);
        if (result != null) {
          emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              requestDetail: TransDetail.GET_DETAIL,
              transLogList: resultLog,
              transDetail: result));
        } else {
          emit(state.copyWith(
              status: BlocStatus.ERROR,
              requestDetail: TransDetail.GET_DETAIL,
              transDetail: null));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, requestDetail: TransDetail.GET_DETAIL));
    }
  }

  void _getTransList(TransactionEvent event, Emitter emit) async {
    try {
      if (event is GetTransListEvent) {
        if (!event.isLoadMore) {
          emit(state.copyWith(
              status: BlocStatus.LOADING,
              request: NewTranstype.GET_TRANS_LIST));
          // Future.
          final futures = [
            getListTrans(
              bankId: event.bankId,
              value: event.value ?? value,
              fromDate: event.fromDate ?? filterTime.fromDate!,
              toDate: event.toDate ?? filterTime.toDate!,
              type: event.type ?? transType,
              index: event.offset ?? 0,
            ),
            getAmountTrans(
              bankId: event.bankId,
              fromDate: event.fromDate ?? filterTime.fromDate!,
              toDate: event.toDate ?? filterTime.toDate!,
            ),
          ];
          final results = await Future.wait(futures);
          List<TransactionItemDTO> transactionList =
              results[0] as List<TransactionItemDTO>;
          TransExtraData? transExtraData = results[1] as TransExtraData?;
          offset = event.offset ?? 0;

          if (transactionList.isNotEmpty) {
            emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              request: NewTranstype.GET_TRANS_LIST,
              transItem: transactionList,
              extraData: transExtraData,
            ));
          } else {
            emit(state.copyWith(
              status: BlocStatus.NONE,
              request: NewTranstype.GET_TRANS_LIST,
              transItem: [],
            ));
          }
        } else {
          offset += 20;
          emit(state.copyWith(
              status: BlocStatus.LOAD_MORE, request: NewTranstype.GET_MORE));
          final result = await _repository.getListTrans(
            bankId: event.bankId,
            value: value,
            fromDate: filterTime.fromDate!,
            toDate: filterTime.toDate!,
            type: transType,
            offset: offset,
          );
          if (result.isNotEmpty) {
            emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              request: NewTranstype.GET_MORE,
              transItem: [...result],
            ));
          } else {
            offset -= 20;
            emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              request: NewTranstype.GET_MORE,
              transItem: [],
            ));
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

  Future<TransExtraData?> getAmountTrans({
    required String bankId,
    required String fromDate,
    required String toDate,
  }) async {
    return await _repository.getTransAmount(
        bankId: bankId, fromDate: fromDate, toDate: toDate);
  }

  Future<List<TransactionItemDTO>> getListTrans({
    required String bankId,
    required String value,
    required String fromDate,
    required String toDate,
    required int type,
    required int index,
  }) async {
    return await _repository.getListTrans(
      bankId: bankId,
      value: value,
      fromDate: fromDate,
      toDate: toDate,
      type: type,
      offset: index,
    );
  }
}
