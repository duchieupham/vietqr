import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class BankTypeState extends Equatable {
  final List<BankTypeDTO> list;
  final BlocStatus status;
  final String? msg;

  const BankTypeState({
    required this.list,
    this.status = BlocStatus.NONE,
    this.msg,
  });

  BankTypeState copyWith(
      {BlocStatus? status, String? msg, List<BankTypeDTO>? list}) {
    return BankTypeState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      list: list ?? this.list,
    );
  }

  @override
  List<Object?> get props => [list];
}
