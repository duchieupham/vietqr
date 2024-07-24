import 'package:equatable/equatable.dart';
import 'package:vierqr/features/bank_detail_new/widgets/filter_time_widget.dart';

class TransactionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SetTransTimeType extends TransactionEvent {
  final FilterTrans filter;

  SetTransTimeType({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class SetTransType extends TransactionEvent {
  final int type;

  SetTransType({required this.type});

  @override
  List<Object?> get props => [type];
}

class SetTransValue extends TransactionEvent {
  final String value;

  SetTransValue({required this.value});

  @override
  List<Object?> get props => [value];
}

class GetTransAmount extends TransactionEvent {
  final String bankId;
  final String? fromDate;
  final String? toDate;

  GetTransAmount({
    required this.bankId,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [
        bankId,
        fromDate,
        toDate,
      ];
}

class GetTransDetailEvent extends TransactionEvent {
  final String id;

  GetTransDetailEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetTransLOGEvent extends TransactionEvent {
  final String id;

  GetTransLOGEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetTransListEvent extends TransactionEvent {
  final String bankId;
  final String? value;
  final String? fromDate;
  final String? toDate;
  final int? type;
  final int? offset;
  final bool isLoadMore;

  GetTransListEvent({
    required this.bankId,
    this.value,
    this.fromDate,
    this.toDate,
    this.type,
    this.offset,
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [
        bankId,
        value,
        fromDate,
        toDate,
        type,
        offset,
        isLoadMore,
      ];
}
