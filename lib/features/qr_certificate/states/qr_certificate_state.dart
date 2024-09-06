import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/ecommerce_request_dto.dart';

class QrCertificateState extends Equatable {
  final String? msg;
  final BlocStatus? status;
  final QrCertificateType request;
  final EcommerceRequest ecommerceRequest;

  const QrCertificateState(
      {this.status = BlocStatus.NONE,
      this.msg,
      this.request = QrCertificateType.NONE,
      required this.ecommerceRequest});

  QrCertificateState copyWith({
    String? msg,
    BlocStatus? status,
    QrCertificateType? request,
    EcommerceRequest? ecommerceRequest,
  }) {
    return QrCertificateState(
      msg: msg ?? this.msg,
      status: status ?? this.status,
      request: request ?? this.request,
      ecommerceRequest: ecommerceRequest ?? this.ecommerceRequest,
    );
  }

  @override
  List<Object?> get props => [msg, status, request, ecommerceRequest];
}
