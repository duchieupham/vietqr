import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_card_request_otp.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/qr_create_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

enum BankType { QR, NONE, SCAN, BANK }

class BankState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final BankType request;
  final String? bankId;
  final String? qr;
  final String? bankAccount;
  final List<BankAccountDTO> listBanks;
  final List<Color> colors;
  final BankCardRequestOTP? dto;
  final TypePermission type;
  final List<QRCreateDTO>? listQR;
  final List<QRGeneratedDTO> listGeneratedQR;
  final BankTypeDTO? bankTypeDTO;

  const BankState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = BankType.NONE,
    this.bankId,
    this.qr,
    required this.listBanks,
    required this.colors,
    this.dto,
    this.type = TypePermission.None,
    this.bankAccount,
    this.bankTypeDTO,
    this.listQR,
    required this.listGeneratedQR,
  });

  BankState copyWith({
    BlocStatus? status,
    BankType? request,
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
    List<QRCreateDTO>? listQR,
    List<QRGeneratedDTO>? listGeneratedQR,
  }) {
    return BankState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      bankId: bankId ?? this.bankId,
      qr: qr ?? this.qr,
      listBanks: listBanks ?? this.listBanks,
      colors: colors ?? this.colors,
      dto: dto ?? this.dto,
      type: type ?? this.type,
      listQR: listQR ?? this.listQR,
      listGeneratedQR: listGeneratedQR ?? this.listGeneratedQR,
      bankAccount: bankAccount ?? this.bankAccount,
      bankTypeDTO: bankTypeDTO ?? this.bankTypeDTO,
    );
  }

  @override
  List<Object?> get props => [
        status,
        request,
        msg,
        bankId,
        qr,
        colors,
        listBanks,
        dto,
        type,
        bankAccount,
        bankTypeDTO,
        listQR,
        listGeneratedQR,
      ];
}
