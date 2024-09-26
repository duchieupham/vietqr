import 'package:equatable/equatable.dart';

class QRBoxEvent extends Equatable {
  const QRBoxEvent();

  @override
  List<Object?> get props => [];
}

class GetMerchantEvent extends QRBoxEvent {
  final String bankId;

  const GetMerchantEvent({required this.bankId});
  @override
  List<Object?> get props => [bankId];
}

class GetTerminalsEvent extends QRBoxEvent {
  final String merchantId;
  final String bankId;

  const GetTerminalsEvent({required this.bankId, required this.merchantId});
  @override
  List<Object?> get props => [bankId, merchantId];
}

class ActiveQRBoxEvent extends QRBoxEvent {
  final String cert;
  final String terminalId;
  final String bankId;

  const ActiveQRBoxEvent(
      {required this.bankId, required this.terminalId, required this.cert});

  @override
  List<Object?> get props => [bankId, terminalId, cert];
}
