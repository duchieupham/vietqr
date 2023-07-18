import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';

enum BankType { QR, NONE, SCAN, BANK, GET_BANK, SCAN_ERROR, SCAN_NOT_FOUND }

class BankState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final BankType request;
  final String? bankAccount;
  final List<BankAccountDTO> listBanks;
  final List<Color> colors;
  final BankTypeDTO? bankTypeDTO;
  final List<BankTypeDTO> listBankTypeDTO;
  final TypeQR typeQR;
  final String? barCode;

  const BankState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = BankType.NONE,
    this.typeQR = TypeQR.NONE,
    this.bankAccount,
    this.bankTypeDTO,
    this.barCode,
    required this.listBanks,
    required this.colors,
    required this.listBankTypeDTO,
  });

  BankState copyWith({
    BlocStatus? status,
    BankType? request,
    String? msg,
    List<BankAccountDTO>? listBanks,
    List<Color>? colors,
    NationalScannerDTO? nationalScannerDTO,
    String? bankAccount,
    List<BankTypeDTO>? listBankTypeDTO,
    BankTypeDTO? bankTypeDTO,
    TypeQR? typeQR,
    String? barCode,
  }) {
    return BankState(
      status: status ?? this.status,
      request: request ?? this.request,
      typeQR: typeQR ?? this.typeQR,
      msg: msg ?? this.msg,
      barCode: barCode ?? this.barCode,
      bankAccount: bankAccount ?? this.bankAccount,
      bankTypeDTO: bankTypeDTO ?? this.bankTypeDTO,
      listBanks: listBanks ?? this.listBanks,
      colors: colors ?? this.colors,
      listBankTypeDTO: listBankTypeDTO ?? this.listBankTypeDTO,
    );
  }

  @override
  List<Object?> get props => [
        status,
        request,
        msg,
        bankAccount,
        colors,
        listBanks,
        typeQR,
        barCode,
      ];
}
