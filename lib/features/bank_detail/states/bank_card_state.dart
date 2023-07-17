import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_card_request_otp.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';

enum BankDetailType { NONE, SUCCESS, DELETED, ERROR }

class BankCardState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final BankDetailType request;
  final String? bankId;
  final String? qr;
  final BankCardRequestOTP? dto;
  final String? requestId;
  final AccountBankDetailDTO? bankDetailDTO;
  final NationalScannerDTO? nationalScannerDTO;
  final String? bankAccount;
  final BankTypeDTO? bankTypeDTO;

  const BankCardState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = BankDetailType.NONE,
    this.bankId,
    this.qr,
    this.dto,
    this.requestId,
    this.bankDetailDTO,
    this.nationalScannerDTO,
    this.bankAccount,
    this.bankTypeDTO,
  });

  BankCardState copyWith({
    BlocStatus? status,
    BankDetailType? request,
    String? msg,
    String? bankId,
    String? qr,
    List<BankAccountDTO>? listBanks,
    List<Color>? colors,
    BankCardRequestOTP? dto,
    String? requestId,
    AccountBankDetailDTO? bankDetailDTO,
    NationalScannerDTO? nationalScannerDTO,
    String? bankAccount,
    BankTypeDTO? bankTypeDTO,
  }) {
    return BankCardState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      bankId: bankId ?? this.bankId,
      qr: qr ?? this.qr,
      dto: dto ?? this.dto,
      requestId: requestId ?? this.requestId,
      bankDetailDTO: bankDetailDTO ?? this.bankDetailDTO,
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
        dto,
        requestId,
        bankDetailDTO,
        nationalScannerDTO,
        bankAccount,
        bankTypeDTO,
      ];
}
