import 'package:equatable/equatable.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class PermissionEventRequest extends HomeEvent {
  const PermissionEventRequest();

  @override
  List<Object?> get props => [];
}

class PermissionEventGetStatus extends HomeEvent {
  const PermissionEventGetStatus();

  @override
  List<Object?> get props => [];
}

class ScanQrEventGetBankType extends HomeEvent {
  final String code;

  const ScanQrEventGetBankType({required this.code});

  @override
  List<Object?> get props => [code];
}
