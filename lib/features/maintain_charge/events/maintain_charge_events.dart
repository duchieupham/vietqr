import 'package:equatable/equatable.dart';
import 'package:vierqr/models/maintain_charge_create.dart';
import 'package:vierqr/models/maintain_charge_dto.dart';

import '../../../models/confirm_manitain_charge_dto.dart';

class MaintainChargeEvents extends Equatable {
  const MaintainChargeEvents();

  @override
  List<Object?> get props => [];
}

class MaintainChargeEvent extends MaintainChargeEvents {
  final MaintainChargeCreate dto;

  const MaintainChargeEvent({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class GetAnnualFeeListEvent extends MaintainChargeEvents {}

class RequestActiveAnnualFeeEvent extends MaintainChargeEvents {
  final int type;
  final String feeId;
  final String bankId;
  final String userId;
  final String password;

  const RequestActiveAnnualFeeEvent(
      {required this.type,
      required this.feeId,
      required this.bankId,
      required this.userId,
      required this.password});

  @override
  List<Object?> get props => [type, feeId, bankId, userId, password];
}

class ConfirmMaintainChargeEvent extends MaintainChargeEvents {
  final ConfirmMaintainCharge dto;

  const ConfirmMaintainChargeEvent({required this.dto});

  @override
  List<Object?> get props => [dto];
}
