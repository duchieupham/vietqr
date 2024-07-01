import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/models/bank_name_information_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/introduce_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class DashBoardState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final DashBoardType request;
  final TypeQR typeQR;
  final DashBoardTypePermission typePermission;
  final NationalScannerDTO? nationalScannerDTO;
  final String? codeQR;
  final String? barCode;
  final List<BankTypeDTO> listBanks;
  final TypeContact typeContact;
  final IntroduceDTO? introduceDTO;
  final AppInfoDTO appInfoDTO;
  final TokenType typeToken;
  final QRGeneratedDTO? qrDto;
  final int countNotify;

  const DashBoardState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = DashBoardType.NONE,
    this.typePermission = DashBoardTypePermission.None,
    this.typeQR = TypeQR.NONE,
    this.nationalScannerDTO,
    this.codeQR,
    this.barCode,
    required this.listBanks,
    this.typeContact = TypeContact.NONE,
    this.introduceDTO,
    required this.appInfoDTO,
    this.typeToken = TokenType.NONE,
    this.qrDto,
    this.countNotify = 0,
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
    QRGeneratedDTO? qrDto,
    // List<ThemeDTO>? themes,
    // ThemeDTO? themeDTO,
    int? countNotify,
  }) {
    return DashBoardState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      typePermission: typePermission ?? this.typePermission,
      typeQR: typeQR ?? this.typeQR,
      nationalScannerDTO: nationalScannerDTO ?? this.nationalScannerDTO,
      codeQR: codeQR ?? this.codeQR,
      barCode: barCode ?? this.barCode,
      request: request ?? this.request,
      listBanks: listBanks ?? this.listBanks,
      typeContact: typeContact ?? this.typeContact,
      introduceDTO: introduceDTO ?? this.introduceDTO,
      appInfoDTO: appInfoDTO ?? this.appInfoDTO,
      typeToken: typeToken ?? this.typeToken,
      qrDto: qrDto ?? this.qrDto,
      // themes: themes ?? this.themes,
      // themeDTO: themeDTO ?? this.themeDTO,
      countNotify: countNotify ?? this.countNotify,
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
        request,
        listBanks,
        typeContact,
        qrDto,
        // themes,
        // themeDTO,
        countNotify,
      ];
}

enum TokenType {
  NONE,
  InValid,
  Valid,
  MainSystem,
  Internet,
  Expired,
  Logout,
  Logout_failed,
  Fcm_success,
  Fcm_failed
}
