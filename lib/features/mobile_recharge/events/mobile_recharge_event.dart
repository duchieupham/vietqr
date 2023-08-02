import 'package:equatable/equatable.dart';

class MobileRechargeEvent extends Equatable {
  const MobileRechargeEvent();

  @override
  List<Object?> get props => [];
}

class MobileRechargeGetListType extends MobileRechargeEvent {}

class MobileRechargeCreateQR extends MobileRechargeEvent {
  final Map<String, dynamic> data;

  const MobileRechargeCreateQR({required this.data});

  @override
  List<Object?> get props => [data];
}
