import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_card_request_otp.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';

enum PopupBankType {
  NONE,
  SUCCESS,
  UN_LINK,
  DELETED,
  OTP,
  UN_BDSD,
  ERROR,
  UPDATE
}

class PopupBankState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final PopupBankType request;
  final BankCardRequestOTP? dto;
  final String? requestId;
  final BankAccountDTO bankAccountDTO;
  final NationalScannerDTO? nationalScannerDTO;
  final String? bankAccount;
  final BankTypeDTO? bankTypeDTO;

  const PopupBankState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = PopupBankType.NONE,
    required this.bankAccountDTO,
    this.dto,
    this.requestId,
    this.nationalScannerDTO,
    this.bankAccount,
    this.bankTypeDTO,
  });

  PopupBankState copyWith({
    BlocStatus? status,
    PopupBankType? request,
    String? msg,
    List<BankAccountDTO>? listBanks,
    List<Color>? colors,
    BankCardRequestOTP? dto,
    String? requestId,
    BankAccountDTO? bankAccountDTO,
    NationalScannerDTO? nationalScannerDTO,
    String? bankAccount,
    BankTypeDTO? bankTypeDTO,
  }) {
    return PopupBankState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      dto: dto ?? this.dto,
      requestId: requestId ?? this.requestId,
      bankAccountDTO: bankAccountDTO ?? this.bankAccountDTO,
      nationalScannerDTO: nationalScannerDTO ?? this.nationalScannerDTO,
      bankAccount: bankAccount ?? this.bankAccount,
      bankTypeDTO: bankTypeDTO ?? this.bankTypeDTO,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        dto,
        requestId,
        bankAccountDTO,
        nationalScannerDTO,
        bankAccount,
        bankTypeDTO,
      ];
}
