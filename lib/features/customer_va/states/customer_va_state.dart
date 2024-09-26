import '../../../commons/enums/enum_type.dart';
import '../../../models/bank_name_information_dto.dart';

class CustomerVaState {
  final String? titleMsg;
  final String? msg;
  final String? errorAccount;
  final String? errorName;
  final BlocStatus status;
  final AddBankType request;
  final BankNameInformationDTO? informationDTO;
  final String? bankAccount;
  final String? bankTypeId;
  final String? bankId;
  final String? qr;
  final String? requestId;
  final String? barCode;
  final TypeQR? typeQR;
  final String? ewalletToken;

  CustomerVaState({
    this.titleMsg,
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = AddBankType.NONE,
    this.typeQR = TypeQR.NONE,
    this.errorAccount,
    this.errorName,
    this.informationDTO,
    this.bankAccount,
    this.bankTypeId,
    this.bankId,
    this.qr,
    this.requestId,
    this.barCode,
    this.ewalletToken,
  });

  CustomerVaState copyWith({
    BlocStatus? status,
    AddBankType? request,
    String? msg,
    String? titleMsg,
    String? errorName,
    String? errorAccount,
    BankNameInformationDTO? informationDTO,
    String? bankAccount,
    String? bankTypeId,
    String? bankId,
    String? qr,
    String? requestId,
    String? barCode,
    TypeQR? typeQR,
    String? ewalletToken,
  }) {
    return CustomerVaState(
      status: status ?? this.status,
      request: request ?? this.request,
      typeQR: typeQR ?? this.typeQR,
      titleMsg: titleMsg ?? this.titleMsg,
      msg: msg ?? this.msg,
      errorAccount: errorAccount ?? this.errorAccount,
      errorName: errorName ?? this.errorName,
      informationDTO: informationDTO ?? this.informationDTO,
      bankAccount: bankAccount ?? this.bankAccount,
      bankTypeId: bankTypeId ?? this.bankTypeId,
      bankId: bankId ?? this.bankId,
      qr: qr ?? this.qr,
      requestId: requestId ?? this.requestId,
      barCode: barCode ?? this.barCode,
      ewalletToken: ewalletToken ?? this.ewalletToken,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerVaState &&
          runtimeType == other.runtimeType &&
          msg == other.msg &&
          status == other.status &&
          request == other.request &&
          errorAccount == other.errorAccount &&
          informationDTO == other.informationDTO &&
          bankAccount == other.bankAccount &&
          bankTypeId == other.bankTypeId &&
          qr == other.qr &&
          bankId == other.bankId &&
          typeQR == other.typeQR &&
          requestId == other.requestId &&
          barCode == other.barCode &&
          ewalletToken == other.ewalletToken &&
          errorName == other.errorName;

  @override
  int get hashCode =>
      msg.hashCode ^
      status.hashCode ^
      request.hashCode ^
      errorAccount.hashCode ^
      errorName.hashCode ^
      typeQR.hashCode ^
      barCode.hashCode ^
      informationDTO.hashCode ^
      bankAccount.hashCode ^
      bankTypeId.hashCode ^
      bankId.hashCode ^
      qr.hashCode ^
      requestId.hashCode ^
      ewalletToken.hashCode;
}
