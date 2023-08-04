import 'package:equatable/equatable.dart';

class MobileRechargeEvent extends Equatable {
  const MobileRechargeEvent();

  @override
  List<Object?> get props => [];
}

class MobileRechargeGetListType extends MobileRechargeEvent {}

class MobileRechargeMobileMoney extends MobileRechargeEvent {
  final Map<String, dynamic> data;

  const MobileRechargeMobileMoney({required this.data});

  @override
  List<Object?> get props => [data];
}

class MobileRechargeUpdateType extends MobileRechargeEvent {
  final Map<String, dynamic> data;

  const MobileRechargeUpdateType({required this.data});

  @override
  List<Object?> get props => [data];
}
