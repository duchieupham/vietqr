import 'package:equatable/equatable.dart';
import 'package:vierqr/features/bank_detail_new/widgets/filter_time_widget.dart';

class TransactionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransTimeType extends TransactionEvent {
  final FilterTrans filter;

  TransTimeType({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class GetTransListEvent extends TransactionEvent {
  final String bankId;
  final String value;
  final String fromDate;
  final String toDate;
  final int type;
  final int? page;
  final int? size;
  final bool isLoadMore;

  GetTransListEvent({
    required this.bankId,
    required this.value,
    required this.fromDate,
    required this.toDate,
    required this.type,
    this.page,
    this.size,
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [
        bankId,
        value,
        fromDate,
        toDate,
        type,
        page,
        size,
        isLoadMore,
      ];
}
