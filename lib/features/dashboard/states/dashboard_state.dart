import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/models/bank_name_information_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/introduce_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';

class DashBoardState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final DashBoardType request;
  final TypeQR typeQR;
  final DashBoardTypePermission typePermission;
  final NationalScannerDTO? nationalScannerDTO;
  final String? codeQR;
  final String? barCode;
  final BankTypeDTO? bankTypeDTO;
  final String bankAccount;
  final List<BankTypeDTO>? listBanks;
  final BankNameInformationDTO? informationDTO;
  final TypeContact typeContact;
  final IntroduceDTO? introduceDTO;
  final AppInfoDTO? appInfoDTO;
  final TokenType typeToken;
  final bool isCheckApp;

  const DashBoardState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = DashBoardType.NONE,
    this.typePermission = DashBoardTypePermission.None,
    this.typeQR = TypeQR.NONE,
    this.nationalScannerDTO,
    this.codeQR,
    this.barCode,
    this.listBanks,
    this.bankTypeDTO,
    this.bankAccount = '',
    this.informationDTO,
    this.typeContact = TypeContact.NONE,
    this.introduceDTO,
    this.appInfoDTO,
    this.typeToken = TokenType.NONE,
    this.isCheckApp = false,
  });

  DashBoardState copyWith({
    BlocStatus? status,
    String? msg,
    DashBoardTypePermission? typePermission,
    NationalScannerDTO? nationalScannerDTO,
    String? codeQR,
    String? barCode,
    BankTypeDTO? bankTypeDTO,
    String? bankAccount,
    DashBoardType? request,
    List<BankTypeDTO>? listBanks,
    TypeQR? typeQR,
    BankNameInformationDTO? informationDTO,
    TypeContact? typeContact,
    IntroduceDTO? introduceDTO,
    TokenType? typeToken,
    AppInfoDTO? appInfoDTO,
    bool? isCheckApp,
  }) {
    return DashBoardState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      typePermission: typePermission ?? this.typePermission,
      typeQR: typeQR ?? this.typeQR,
      nationalScannerDTO: nationalScannerDTO ?? this.nationalScannerDTO,
      codeQR: codeQR ?? this.codeQR,
      barCode: barCode ?? this.barCode,
      bankTypeDTO: bankTypeDTO ?? this.bankTypeDTO,
      bankAccount: bankAccount ?? this.bankAccount,
      request: request ?? this.request,
      listBanks: listBanks ?? this.listBanks,
      informationDTO: informationDTO ?? this.informationDTO,
      typeContact: typeContact ?? this.typeContact,
      introduceDTO: introduceDTO ?? this.introduceDTO,
      appInfoDTO: appInfoDTO ?? this.appInfoDTO,
      typeToken: typeToken ?? this.typeToken,
      isCheckApp: isCheckApp ?? this.isCheckApp,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        typePermission,
        typeQR,
        nationalScannerDTO,
        codeQR,
        barCode,
        bankTypeDTO,
        bankAccount,
        request,
        listBanks,
        informationDTO,
        typeContact,
      ];
}
