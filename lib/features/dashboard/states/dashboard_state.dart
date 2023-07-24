import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/bank_name_information_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';

enum DashBoardType {
  GET_BANK,
  NONE,
  SCAN_ERROR,
  SCAN_NOT_FOUND,
  SCAN,
  SEARCH_BANK_NAME,
  ADD_BOOK_CONTACT,
  ADD_BOOK_CONTACT_EXIST,
}

enum DashBoardTypePermission {
  None,
  CameraDenied,
  CameraAllow,
  CameraRequest,
  Allow,
  Request,
  Denied,
  Error,
}

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
  final TypePhoneBook? typePhoneBook;

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
    this.typePhoneBook,
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
    TypePhoneBook? typePhoneBook,
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
      typePhoneBook: typePhoneBook ?? this.typePhoneBook,
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
        typePhoneBook,
      ];
}
