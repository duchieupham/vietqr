import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/related_transaction_receive_dto.dart';

enum TransHistoryType {
  NONE,
  ERROR,
  LOAD_DATA,
}

class TransHistoryState extends Equatable {
  final BlocStatus status;
  final TransHistoryType type;
  final String? msg;
  final List<RelatedTransactionReceiveDTO> list;
  final int offset;
  final bool isLoadMore;

  const TransHistoryState({
    this.status = BlocStatus.NONE,
    this.type = TransHistoryType.NONE,
    this.msg,
    required this.list,
    this.offset = 0,
    this.isLoadMore = false,
  });

  TransHistoryState copyWith({
    BlocStatus? status,
    TransHistoryType? type,
    String? msg,
    List<RelatedTransactionReceiveDTO>? list,
    int? offset,
    bool? isLoadMore,
  }) {
    return TransHistoryState(
      status: status ?? this.status,
      type: type ?? this.type,
      msg: msg ?? this.msg,
      list: list ?? this.list,
    );
  }

  @override
  List<Object?> get props => [status, type, msg, list];
}
