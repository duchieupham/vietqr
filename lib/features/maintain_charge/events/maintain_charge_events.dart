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

class ConfirmMaintainChargeEvent extends MaintainChargeEvents {
  final ConfirmMaintainCharge dto;

  const ConfirmMaintainChargeEvent({required this.dto});

  @override
  List<Object?> get props => [dto];
}
