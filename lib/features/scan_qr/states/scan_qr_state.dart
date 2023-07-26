import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/bank_name_information_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';

class ScanQrState extends Equatable {
  final BlocStatus status;
  final String? msg;
  final ScanType request;
  final TypeQR typeQR;
  final BankTypeDTO? bankTypeDTO;
  final String? bankAccount;
  final NationalScannerDTO? nationalScannerDTO;
  final String? codeQR;
  final TypeContact typeContact;
  final BankNameInformationDTO? informationDTO;

  const ScanQrState({
    this.status = BlocStatus.NONE,
    this.msg,
    this.request = ScanType.NONE,
    this.typeQR = TypeQR.NONE,
    this.bankTypeDTO,
    this.bankAccount,
    this.nationalScannerDTO,
    this.codeQR,
    this.typeContact = TypeContact.NONE,
    this.informationDTO,
  });

  ScanQrState copyWith({
    BlocStatus? status,
    String? msg,
    ScanType? request,
    BankTypeDTO? bankTypeDTO,
    String? bankAccount,
    NationalScannerDTO? nationalScannerDTO,
    String? codeQR,
    TypeContact? typeContact,
    BankNameInformationDTO? informationDTO,
    TypeQR? typeQR,
  }) {
    return ScanQrState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      request: request ?? this.request,
      typeQR: typeQR ?? this.typeQR,
      bankTypeDTO: bankTypeDTO ?? this.bankTypeDTO,
      bankAccount: bankAccount ?? this.bankAccount,
      nationalScannerDTO: nationalScannerDTO ?? this.nationalScannerDTO,
      codeQR: codeQR ?? this.codeQR,
      typeContact: typeContact ?? this.typeContact,
      informationDTO: informationDTO ?? this.informationDTO,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        request,
        bankTypeDTO,
        bankAccount,
        nationalScannerDTO,
        codeQR,
        typeContact,
        informationDTO,
        typeQR,
      ];
}

// class ScanQrInitialState extends ScanQrState {}
//
// class ScanQrLoadingState extends ScanQrState {}
//
// class ScanQrNotFoundInformation extends ScanQrState {}
//
// class ScanQrGetBankTypeSuccessState extends ScanQrState {
//   final BankTypeDTO dto;
//   final String bankAccount;
//
//   const ScanQrGetBankTypeSuccessState({
//     required this.dto,
//     required this.bankAccount,
//   });
//
//   @override
//   List<Object?> get props => [dto, bankAccount];
// }
//
// class ScanQrGetBankTypeFailedState extends ScanQrState {}
//
// class QRScanGetNationalInformationSuccessState extends ScanQrState {
//   final NationalScannerDTO dto;
//
//   const QRScanGetNationalInformationSuccessState({
//     required this.dto,
//   });
//
//   @override
//   List<Object?> get props => [dto];
// }
