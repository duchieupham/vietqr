import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/trans_list_dto.dart';
import 'package:vierqr/models/transaction_log_dto.dart';

import '../widgets/filter_time_widget.dart';

// ignore: constant_identifier_names
enum NewTranstype {
  NONE,
  ERROR,
  GET_TRANS_LIST,
  GET_TRANS_AMOUNT,
  GET_MORE,
  FILTER
}

enum TransDetail {
  NONE,
  ERROR,
  GET_DETAIL,
  REGENERATE_QR,
  LOG,
}

class TransactionState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final NewTranstype request;
  final TransDetail requestDetail;

  final FilterTrans? filter;
  final List<TransactionItemDTO>? transItem;
  final TransExtraData? extraData;
  final TransactionItemDetailDTO? transDetail;
  final List<TransactionLogDTO>? transLogList;
  final QRGeneratedDTO? generateQr;

  const TransactionState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = NewTranstype.NONE,
    this.requestDetail = TransDetail.NONE,
    this.filter,
    this.transItem,
    this.extraData,
    this.transDetail,
    this.transLogList,
    this.generateQr,
  });

  TransactionState copyWith({
    BlocStatus? status,
    NewTranstype? request,
    TransDetail? requestDetail,
    String? msg,
    FilterTrans? filter,
    List<TransactionItemDTO>? transItem,
    TransExtraData? extraData,
    TransactionItemDetailDTO? transDetail,
    List<TransactionLogDTO>? transLogList,
    QRGeneratedDTO? generateQr,
  }) {
    return TransactionState(
      status: status ?? this.status,
      request: request ?? this.request,
      requestDetail: requestDetail ?? this.requestDetail,
      msg: msg ?? this.msg,
      filter: filter ?? this.filter,
      transItem: transItem ?? this.transItem,
      extraData: extraData ?? this.extraData,
      transDetail: transDetail ?? this.transDetail,
      transLogList: transLogList ?? this.transLogList,
      generateQr: generateQr ?? this.generateQr,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        request,
        requestDetail,
        filter,
        transItem,
        extraData,
        transDetail,
        transLogList,
        generateQr,
      ];
}
