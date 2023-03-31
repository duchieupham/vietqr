import 'package:equatable/equatable.dart';

class ScanQrEvent extends Equatable {
  const ScanQrEvent();

  @override
  List<Object?> get props => [];
}

class ScanQrEventGetBankType extends ScanQrEvent {
  final String code;

  const ScanQrEventGetBankType({required this.code});

  @override
  List<Object?> get props => [code];
}
