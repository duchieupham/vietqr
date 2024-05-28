import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/store/merchant_dto.dart';
import 'package:vierqr/models/terminal_qr_dto.dart';

enum QR_Box { NONE, GET_BANKS, GET_MERCHANTS, GET_TERMINALS, ACTIVE }

class QRBoxState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final QR_Box request;
  final List<MerchantDTO>? listMerchant;
  final List<TerminalQRDTO>? listTerminal;

  const QRBoxState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = QR_Box.NONE,
    this.listMerchant,
    this.listTerminal,
  });

  QRBoxState copyWith({
    BlocStatus? status,
    QR_Box? request,
    String? msg,
    List<MerchantDTO>? listMerchant,
    List<TerminalQRDTO>? listTerminal,
  }) {
    return QRBoxState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      listMerchant: listMerchant ?? this.listMerchant,
      listTerminal: listTerminal ?? this.listTerminal,
    );
  }

  @override
  List<Object?> get props => [msg, status, request, listMerchant, listTerminal];
}
