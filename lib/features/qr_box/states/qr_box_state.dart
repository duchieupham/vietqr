import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';

enum QR_Box { NONE, GET_BANKS, GET_MERCHANTS }

class QRBoxState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final QR_Box request;

  const QRBoxState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = QR_Box.NONE,
  });

  QRBoxState copyWith({
    BlocStatus? status,
    QR_Box? request,
    String? msg,
  }) {
    return QRBoxState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
    );
  }

  @override
  List<Object?> get props => [msg, status, request];
}
