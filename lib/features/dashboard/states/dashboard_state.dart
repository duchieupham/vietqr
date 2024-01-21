import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/models/bank_name_information_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/introduce_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/theme_dto.dart';

class DashBoardState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final DashBoardType request;
  final TypeQR typeQR;
  final DashBoardTypePermission typePermission;
  final NationalScannerDTO? nationalScannerDTO;
  final String? codeQR;
  final String? barCode;
  final List<BankTypeDTO>? listBanks;
  final TypeContact typeContact;
  final IntroduceDTO? introduceDTO;
  final AppInfoDTO? appInfoDTO;
  final TokenType typeToken;
  final bool isCheckApp;
  final QRGeneratedDTO? qrDto;
  final List<ThemeDTO> themes;
  final ThemeDTO? themeDTO;
  final bool keepValue;

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
    this.typeContact = TypeContact.NONE,
    this.introduceDTO,
    this.appInfoDTO,
    this.typeToken = TokenType.NONE,
    this.isCheckApp = false,
    this.keepValue = false,
    this.qrDto,
    this.themeDTO,
    required this.themes,
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
    QRGeneratedDTO? qrDto,
    List<ThemeDTO>? themes,
    ThemeDTO? themeDTO,
    bool? keepValue,
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
      isCheckApp: isCheckApp ?? this.isCheckApp,
      qrDto: qrDto ?? this.qrDto,
      themes: themes ?? this.themes,
      themeDTO: themeDTO ?? this.themeDTO,
      keepValue: keepValue ?? this.keepValue,
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
        themes,
        themeDTO,
        keepValue,
      ];
}
