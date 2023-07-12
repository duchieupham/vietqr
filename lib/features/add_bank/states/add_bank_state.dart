import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/models/bank_name_information_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class AddBankState {
  final String? msg;
  final String? errorAccount;
  final String? errorName;
  final BlocStatus status;
  final BlocRequest request;
  final List<BankTypeDTO>? listBanks;
  final BankTypeDTO? bankSelected;
  final BankNameInformationDTO? informationDTO;
  final String? bankAccount;
  final String? bankTypeId;
  final String? bankId;
  final String? qr;

  AddBankState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = BlocRequest.NONE,
    this.listBanks,
    this.bankSelected,
    this.errorAccount,
    this.errorName,
    this.informationDTO,
    this.bankAccount,
    this.bankTypeId,
    this.bankId,
    this.qr,
  });

  AddBankState copyWith({
    BlocStatus? status,
    BlocRequest? request,
    String? msg,
    String? errorName,
    String? errorAccount,
    List<BankTypeDTO>? listBanks,
    BankTypeDTO? bankSelected,
    BankNameInformationDTO? informationDTO,
    String? bankAccount,
    String? bankTypeId,
    String? bankId,
    String? qr,
  }) {
    return AddBankState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      errorAccount: errorAccount ?? this.errorAccount,
      errorName: errorName ?? this.errorName,
      listBanks: listBanks ?? this.listBanks,
      bankSelected: bankSelected ?? this.bankSelected,
      informationDTO: informationDTO ?? this.informationDTO,
      bankAccount: bankAccount ?? this.bankAccount,
      bankTypeId: bankTypeId ?? this.bankTypeId,
      bankId: bankId ?? this.bankId,
      qr: qr ?? this.qr,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddBankState &&
          runtimeType == other.runtimeType &&
          msg == other.msg &&
          status == other.status &&
          request == other.request &&
          listBanks == other.listBanks &&
          bankSelected == other.bankSelected &&
          errorAccount == other.errorAccount &&
          informationDTO == other.informationDTO &&
          bankAccount == other.bankAccount &&
          bankTypeId == other.bankTypeId &&
          qr == other.qr &&
          bankId == other.bankId &&
          errorName == other.errorName;

  @override
  int get hashCode =>
      msg.hashCode ^
      status.hashCode ^
      request.hashCode ^
      listBanks.hashCode ^
      errorAccount.hashCode ^
      errorName.hashCode ^
      informationDTO.hashCode ^
      bankAccount.hashCode ^
      bankTypeId.hashCode ^
      bankId.hashCode ^
      qr.hashCode ^
      bankSelected.hashCode;
}
