import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_card_request_otp.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';

class BankState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final String? bankId;
  final String? qr;
  final List<BankAccountDTO> listBanks;
  final List<Color> colors;
  final BankCardRequestOTP? dto;
  final String? requestId;
  final AccountBankDetailDTO? bankDetailDTO;
  final TypePermission type;
  final NationalScannerDTO? nationalScannerDTO;
  final String? bankAccount;
  final BankTypeDTO? bankTypeDTO;

  const BankState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.bankId,
    this.qr,
    required this.listBanks,
    required this.colors,
    this.dto,
    this.requestId,
    this.bankDetailDTO,
    this.type = TypePermission.None,
    this.nationalScannerDTO,
    this.bankAccount,
    this.bankTypeDTO,
  });

  BankState copyWith({
    BlocStatus? status,
    String? msg,
    String? bankId,
    String? qr,
    List<BankAccountDTO>? listBanks,
    List<Color>? colors,
    BankCardRequestOTP? dto,
    String? requestId,
    AccountBankDetailDTO? bankDetailDTO,
    TypePermission? type,
    NationalScannerDTO? nationalScannerDTO,
    String? bankAccount,
    BankTypeDTO? bankTypeDTO,
  }) {
    return BankState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      bankId: bankId ?? this.bankId,
      qr: qr ?? this.qr,
      listBanks: listBanks ?? this.listBanks,
      colors: colors ?? this.colors,
      dto: dto ?? this.dto,
      requestId: requestId ?? this.requestId,
      bankDetailDTO: bankDetailDTO ?? this.bankDetailDTO,
      type: type ?? this.type,
      nationalScannerDTO: nationalScannerDTO ?? this.nationalScannerDTO,
      bankAccount: bankAccount ?? this.bankAccount,
      bankTypeDTO: bankTypeDTO ?? this.bankTypeDTO,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        bankId,
        qr,
        colors,
        listBanks,
        dto,
        requestId,
        bankDetailDTO,
        type,
        nationalScannerDTO,
        bankAccount,
        bankTypeDTO,
      ];
}
