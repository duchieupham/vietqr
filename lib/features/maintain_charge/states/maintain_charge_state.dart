import 'package:equatable/equatable.dart';
import 'package:vierqr/models/maintain_charge_dto.dart';

import '../../../commons/enums/enum_type.dart';
import '../../../models/maintain_charge_create.dart';

class MaintainChargeState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final MainChargeType request;
  final MaintainChargeDTO? dto;
  final MaintainChargeCreate? createDto;

  const MaintainChargeState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = MainChargeType.NONE,
    this.dto,
    this.createDto,
  });

  MaintainChargeState copyWith({
    BlocStatus? status,
    MainChargeType? request,
    String? msg,
    MaintainChargeDTO? dto,
    MaintainChargeCreate? createDto,
  }) {
    return MaintainChargeState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      dto: dto ?? this.dto,
      createDto: createDto ?? this.createDto,
    );
  }

  @override
  List<Object?> get props => [
        status,
        request,
        msg,
        dto,
        createDto,
      ];
}
