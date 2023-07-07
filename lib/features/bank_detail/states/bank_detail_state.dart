import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class BankDetailState {
  final String? msg;
  final BlocStatus status;
  final AccountBankDetailDTO? bankDetailDTO;
  final String? bankId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankDetailState &&
          runtimeType == other.runtimeType &&
          msg == other.msg &&
          status == other.status &&
          bankDetailDTO == other.bankDetailDTO &&
          bankId == other.bankId;

  @override
  int get hashCode =>
      msg.hashCode ^ status.hashCode ^ bankDetailDTO.hashCode ^ bankId.hashCode;

  BankDetailState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.bankDetailDTO,
    this.bankId,
  });

  BankDetailState copyWith({
    BlocStatus? status,
    String? msg,
    String? bankId,
    String? qr,
    String? requestId,
    AccountBankDetailDTO? bankDetailDTO,
  }) {
    return BankDetailState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      bankId: bankId ?? this.bankId,
      bankDetailDTO: bankDetailDTO ?? this.bankDetailDTO,
    );
  }
}
