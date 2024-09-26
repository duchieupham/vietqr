import 'package:equatable/equatable.dart';

class QRCodeUnUTEvent extends Equatable {
  const QRCodeUnUTEvent();

  @override
  List<Object?> get props => [];
}

class QRCodeUnUTCreateQR extends QRCodeUnUTEvent {
  final Map<String, dynamic> data;
  const QRCodeUnUTCreateQR({required this.data});

  @override
  List<Object?> get props => [data];
}

class LoadDataBankTypeEvent extends QRCodeUnUTEvent {}
