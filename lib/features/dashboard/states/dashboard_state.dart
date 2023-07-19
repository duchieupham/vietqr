import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';

enum DashBoardType { GET_BANK, NONE, SCAN_ERROR, SCAN_NOT_FOUND, SCAN }

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
  });

  DashBoardState copyWith({
    BlocStatus? status,
    String? msg,
    DashBoardTypePermission? type,
    NationalScannerDTO? nationalScannerDTO,
    String? codeQR,
    String? barCode,
    BankTypeDTO? bankTypeDTO,
    String? bankAccount,
    DashBoardType? request,
    List<BankTypeDTO>? listBanks,
    TypeQR? typeQR,
  }) {
    return DashBoardState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      typePermission: type ?? this.typePermission,
      typeQR: typeQR ?? this.typeQR,
      nationalScannerDTO: nationalScannerDTO ?? this.nationalScannerDTO,
      codeQR: codeQR ?? this.codeQR,
      barCode: barCode ?? this.barCode,
      bankTypeDTO: bankTypeDTO ?? this.bankTypeDTO,
      bankAccount: bankAccount ?? this.bankAccount,
      request: request ?? this.request,
      listBanks: listBanks ?? this.listBanks,
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
        listBanks
      ];
}
