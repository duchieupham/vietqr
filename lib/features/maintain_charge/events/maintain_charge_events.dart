import 'package:equatable/equatable.dart';
import 'package:vierqr/models/maintain_charge_create.dart';

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

class GetAnnualFeeListEvent extends MaintainChargeEvents {
  final String bankId;

  const GetAnnualFeeListEvent({required this.bankId});

  @override
  List<Object?> get props => [bankId];
}

class RequestActiveAnnualFeeEvent extends MaintainChargeEvents {
  final int type;
  final String feeId;
  final String bankId;
  final String bankCode;
  final String bankName;
  final String bankAccount;
  final String userBankName;

  final String userId;
  final String password;

  const RequestActiveAnnualFeeEvent(
      {required this.type,
      required this.feeId,
      required this.bankId,
      required this.bankCode,
      required this.bankName,
      required this.bankAccount,
      required this.userBankName,
      required this.userId,
      required this.password});

  @override
  List<Object?> get props =>
      [type, feeId, bankId, bankCode, bankName, userId, password];
}

class ConfirmMaintainChargeEvent extends MaintainChargeEvents {
  final ConfirmMaintainCharge dto;

  const ConfirmMaintainChargeEvent({required this.dto});

  @override
  List<Object?> get props => [dto];
}
