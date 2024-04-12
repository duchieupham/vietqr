import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/trans_dto.dart';
import 'package:vierqr/models/terminal_response_dto.dart';

class TransHistoryState extends Equatable {
  final BlocStatus status;
  final TransHistoryType type;
  final String? msg;
  final List<TransDTO> list;
  final int offset;
  final TerminalDto terminalDto;
  final TerminalAccountDTO terminalAccountDto;
  final bool isEmpty;
  final bool isLoadMore;

  const TransHistoryState({
    this.status = BlocStatus.NONE,
    this.type = TransHistoryType.NONE,
    this.msg,
    required this.list,
    this.offset = 0,
    this.isEmpty = false,
    this.isLoadMore = false,
    required this.terminalDto,
    required this.terminalAccountDto,
  });

  TransHistoryState copyWith({
    BlocStatus? status,
    TransHistoryType? type,
    String? msg,
    List<TransDTO>? list,
    int? offset,
    TerminalDto? terminalDto,
    TerminalAccountDTO? terminalAccountDto,
    bool? isLoadMore,
    bool? isEmpty,
  }) {
    return TransHistoryState(
      status: status ?? this.status,
      type: type ?? this.type,
      msg: msg ?? this.msg,
      list: list ?? this.list,
      terminalDto: terminalDto ?? this.terminalDto,
      terminalAccountDto: terminalAccountDto ?? this.terminalAccountDto,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      isEmpty: isEmpty ?? this.isEmpty,
      offset: offset ?? this.offset,
    );
  }

  @override
  List<Object?> get props =>
      [status, type, msg, list, offset, isLoadMore, isEmpty];
}
