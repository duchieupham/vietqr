import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class AddBankState {
  final String? msg;
  final String? errorAccount;
  final String? errorName;
  final BlocStatus status;
  final List<BankTypeDTO>? listBanks;
  final BankTypeDTO? bankSelected;

  AddBankState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.listBanks,
    this.bankSelected,
    this.errorAccount,
    this.errorName,
  });

  AddBankState copyWith({
    BlocStatus? status,
    String? msg,
    String? errorName,
    String? errorAccount,
    List<BankTypeDTO>? listBanks,
    BankTypeDTO? bankSelected,
  }) {
    return AddBankState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      errorAccount: errorAccount ?? this.errorAccount,
      errorName: errorName ?? this.errorName,
      listBanks: listBanks ?? this.listBanks,
      bankSelected: bankSelected ?? this.bankSelected,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddBankState &&
          runtimeType == other.runtimeType &&
          msg == other.msg &&
          status == other.status &&
          listBanks == other.listBanks &&
          bankSelected == other.bankSelected &&
          errorAccount == other.errorAccount &&
          errorName == other.errorName;

  @override
  int get hashCode =>
      msg.hashCode ^
      status.hashCode ^
      listBanks.hashCode ^
      errorAccount.hashCode ^
      errorName.hashCode ^
      bankSelected.hashCode;
}
