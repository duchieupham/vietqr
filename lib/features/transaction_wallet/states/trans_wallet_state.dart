import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/trans_wallet_dto.dart';

class TransWalletState extends Equatable {
  final BlocStatus status;
  final TransHistoryType type;
  final String? msg;
  final List<TransWalletDto> list;
  final int offset;
  final bool isLoadMore;

  const TransWalletState({
    this.status = BlocStatus.NONE,
    this.type = TransHistoryType.NONE,
    this.msg,
    required this.list,
    this.offset = 0,
    this.isLoadMore = false,
  });

  TransWalletState copyWith({
    BlocStatus? status,
    TransHistoryType? type,
    String? msg,
    List<TransWalletDto>? list,
    int? offset,
    bool? isLoadMore,
  }) {
    return TransWalletState(
      status: status ?? this.status,
      type: type ?? this.type,
      msg: msg ?? this.msg,
      list: list ?? this.list,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      offset: offset ?? this.offset,
    );
  }

  @override
  List<Object?> get props => [status, type, msg, list, offset, isLoadMore];
}
