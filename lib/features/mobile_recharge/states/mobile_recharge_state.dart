import 'package:equatable/equatable.dart';
import 'package:vierqr/models/network_providers_dto.dart';
import 'package:vierqr/models/respone_top_up_dto.dart';

class MobileRechargeState extends Equatable {
  const MobileRechargeState();

  @override
  List<Object?> get props => [];
}

class MobileRechargeInitialState extends MobileRechargeState {}

class MobileRechargeLoadingState extends MobileRechargeState {}

class MobileRechargeGetListTypeSuccessState extends MobileRechargeState {
  final List<NetworkProviders> list;

  const MobileRechargeGetListTypeSuccessState({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}

class MobileRechargeGetListTypeFailedState extends MobileRechargeState {}

class MobileRechargeCreateQrSuccessState extends MobileRechargeState {
  final ResponseTopUpDTO dto;

  const MobileRechargeCreateQrSuccessState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class MobileRechargeCreateQrFailedState extends MobileRechargeState {}
