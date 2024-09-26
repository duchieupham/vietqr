import 'package:equatable/equatable.dart';
import 'package:vierqr/models/ecommerce_request_dto.dart';

class QrCertificateEvent extends Equatable {
  const QrCertificateEvent();

  @override
  List<Object?> get props => [];
}

class ScanQrCertificateEvent extends QrCertificateEvent {
  final String qrCode;
  const ScanQrCertificateEvent({required this.qrCode});
  @override
  List<Object?> get props => [qrCode];
}

class EcomActiveQrCertificateEvent extends QrCertificateEvent {
  final EcommerceRequest request;
  const EcomActiveQrCertificateEvent({required this.request});
  @override
  List<Object?> get props => [request];
}
