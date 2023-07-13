import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/business_item_dto.dart';

class DashboardState extends Equatable {
  final List<BusinessItemDTO> list;
  final BlocStatus status;
  final String? msg;

  const DashboardState({
    this.list = const [],
    this.status = BlocStatus.NONE,
    this.msg,
  });

  DashboardState copyWith({
    List<BusinessItemDTO>? list,
    BlocStatus? status,
    String? msg,
  }) {
    return DashboardState(
      list: list ?? this.list,
      status: status ?? this.status,
      msg: msg ?? this.msg,
    );
  }

  @override
  List<Object?> get props => [list, status, msg];
}
