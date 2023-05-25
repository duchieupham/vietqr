import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';

class ScanQrState extends Equatable {
  const ScanQrState();

  @override
  List<Object?> get props => [];
}

class ScanQrInitialState extends ScanQrState {}

class ScanQrLoadingState extends ScanQrState {}

class ScanQrNotFoundInformation extends ScanQrState {}

class ScanQrGetBankTypeSuccessState extends ScanQrState {
  final BankTypeDTO dto;
  final String bankAccount;

  const ScanQrGetBankTypeSuccessState({
    required this.dto,
    required this.bankAccount,
  });

  @override
  List<Object?> get props => [dto, bankAccount];
}

class ScanQrGetBankTypeFailedState extends ScanQrState {}

class QRScanGetNationalInformationSuccessState extends ScanQrState {
  final NationalScannerDTO dto;

  const QRScanGetNationalInformationSuccessState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}
