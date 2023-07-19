import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/business_item_dto.dart';

class BusinessState extends Equatable {
  final List<BusinessItemDTO> list;
  final BlocStatus status;
  final String? msg;

  const BusinessState({
    this.list = const [],
    this.status = BlocStatus.NONE,
    this.msg,
  });

  BusinessState copyWith({
    List<BusinessItemDTO>? list,
    BlocStatus? status,
    String? msg,
  }) {
    return BusinessState(
      list: list ?? this.list,
      status: status ?? this.status,
      msg: msg ?? this.msg,
    );
  }

  @override
  List<Object?> get props => [list, status, msg];
}
