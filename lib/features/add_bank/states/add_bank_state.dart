import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/bank_card_request_otp.dart';
import 'package:vierqr/models/bank_name_information_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class AddBankState {
  final String? titleMsg;
  final String? msg;
  final String? errorAccount;
  final String? errorName;
  final BlocStatus status;
  final AddBankType request;
  final List<BankTypeDTO>? listBanks;
  final BankTypeDTO? bankSelected;
  final BankNameInformationDTO? informationDTO;
  final String? bankAccount;
  final String? bankTypeId;
  final String? bankId;
  final String? qr;
  final BankCardRequestOTP? dto;
  final String? requestId;
  final String? barCode;
  final TypeQR? typeQR;
  final String? ewalletToken;
  final DataObject? responseDataOTP;
  final bool isSaveButton;

  AddBankState({
    this.titleMsg,
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = AddBankType.NONE,
    this.typeQR = TypeQR.NONE,
    this.listBanks,
    this.bankSelected,
    this.errorAccount,
    this.errorName,
    this.informationDTO,
    this.bankAccount,
    this.bankTypeId,
    this.bankId,
    this.qr,
    this.dto,
    this.requestId,
    this.barCode,
    this.ewalletToken,
    this.responseDataOTP,
    this.isSaveButton = false,
  });

  AddBankState copyWith({
    BlocStatus? status,
    AddBankType? request,
    String? msg,
    String? titleMsg,
    String? errorName,
    String? errorAccount,
    List<BankTypeDTO>? listBanks,
    BankTypeDTO? bankSelected,
    BankNameInformationDTO? informationDTO,
    String? bankAccount,
    String? bankTypeId,
    String? bankId,
    String? qr,
    BankCardRequestOTP? dto,
    String? requestId,
    String? barCode,
    TypeQR? typeQR,
    String? ewalletToken,
    DataObject? responseDataOTP,
    bool? isSaveButton
  }) {
    return AddBankState(
      status: status ?? this.status,
      request: request ?? this.request,
      typeQR: typeQR ?? this.typeQR,
      titleMsg: titleMsg ?? this.titleMsg,
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
      dto: dto ?? this.dto,
      requestId: requestId ?? this.requestId,
      barCode: barCode ?? this.barCode,
      ewalletToken: ewalletToken ?? this.ewalletToken,
      responseDataOTP: responseDataOTP ?? this.responseDataOTP,
      isSaveButton: isSaveButton ?? this.isSaveButton
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
          dto == other.dto &&
          typeQR == other.typeQR &&
          requestId == other.requestId &&
          barCode == other.barCode &&
          ewalletToken == other.ewalletToken &&
          errorName == other.errorName &&
          responseDataOTP == other.responseDataOTP;

  @override
  int get hashCode =>
      msg.hashCode ^
      status.hashCode ^
      request.hashCode ^
      listBanks.hashCode ^
      errorAccount.hashCode ^
      errorName.hashCode ^
      typeQR.hashCode ^
      barCode.hashCode ^
      informationDTO.hashCode ^
      bankAccount.hashCode ^
      bankTypeId.hashCode ^
      bankId.hashCode ^
      qr.hashCode ^
      dto.hashCode ^
      requestId.hashCode ^
      ewalletToken.hashCode ^
      bankSelected.hashCode;
}
