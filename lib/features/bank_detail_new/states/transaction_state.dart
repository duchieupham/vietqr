import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/metadata_dto.dart';
import 'package:vierqr/models/trans_list_dto.dart';

import '../widgets/filter_time_widget.dart';

// ignore: constant_identifier_names
enum NewTranstype { NONE, ERROR, GET_TRANS_LIST, FILTER }

class TransactionState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final NewTranstype request;
  final FilterTrans? filter;
  final List<TransItem>? transItem;
  final TransExtraData? extraData;

  const TransactionState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = NewTranstype.NONE,
    this.filter,
    this.transItem,
    this.extraData,
  });

  TransactionState copyWith({
    BlocStatus? status,
    NewTranstype? request,
    String? msg,
    FilterTrans? filter,
    List<TransItem>? transItem,
    TransExtraData? extraData,
    MetaDataDTO? metadata,
  }) {
    return TransactionState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      filter: filter ?? this.filter,
      transItem: transItem ?? this.transItem,
      extraData: extraData ?? this.extraData,
    );
  }

  @override
  List<Object?> get props =>
      [status, msg, request, filter, transItem, extraData];
}
