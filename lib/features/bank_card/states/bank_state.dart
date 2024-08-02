import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_account_terminal.dart';
import 'package:vierqr/models/bank_overview_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/key_free_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/nearest_transaction_dto.dart';
import 'package:vierqr/services/providers/invoice_overview_dto.dart';

class BankState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final BankType request;
  final String? bankAccount;
  final List<BankAccountDTO> listBanks;
  final List<NearestTransDTO> listTrans;
  final BankAccountDTO? bankSelect;
  final BankOverviewDTO? overviewDto;
  final InvoiceOverviewDTO? invoiceOverviewDTO;
  // final List<Color> colors;
  final KeyFreeDTO? keyDTO;
  final BankTypeDTO? bankTypeDTO;
  final List<BankTypeDTO> listBankTypeDTO;
  final TypeQR typeQR;
  final String? barCode;
  final bool isEmpty;
  final bool isBankSelect;
  final List<BankAccountTerminal> listBankAccountTerminal;

  const BankState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = BankType.NONE,
    this.typeQR = TypeQR.NONE,
    this.bankAccount,
    this.bankTypeDTO,
    this.barCode,
    this.overviewDto,
    required this.listBanks,
    required this.listTrans,
    this.bankSelect,
    this.keyDTO,
    this.invoiceOverviewDTO,
    required this.listBankTypeDTO,
    this.isEmpty = false,
    this.isBankSelect = false,
    required this.listBankAccountTerminal,
  });

  BankState copyWith({
    BlocStatus? status,
    BankType? request,
    String? msg,
    List<BankAccountDTO>? listBanks,
    List<NearestTransDTO>? listTrans,
    BankAccountDTO? bankSelect,
    List<BankAccountTerminal>? listBankTerminal,
    // List<Color>? colors,
    NationalScannerDTO? nationalScannerDTO,
    String? bankAccount,
    BankOverviewDTO? overviewDto,
    KeyFreeDTO? keyDTO,
    InvoiceOverviewDTO? invoiceOverviewDTO,
    List<BankTypeDTO>? listBankTypeDTO,
    BankTypeDTO? bankTypeDTO,
    TypeQR? typeQR,
    String? barCode,
    bool? isEmpty,
    bool? isBankSelect,
  }) {
    return BankState(
      status: status ?? this.status,
      request: request ?? this.request,
      typeQR: typeQR ?? this.typeQR,
      msg: msg ?? this.msg,
      listBankAccountTerminal: listBankTerminal ?? listBankAccountTerminal,
      barCode: barCode ?? this.barCode,
      bankAccount: bankAccount ?? this.bankAccount,
      bankTypeDTO: bankTypeDTO ?? this.bankTypeDTO,
      listTrans: listTrans ?? this.listTrans,
      listBanks: listBanks ?? this.listBanks,
      bankSelect: bankSelect ?? this.bankSelect,
      overviewDto: overviewDto ?? this.overviewDto,
      invoiceOverviewDTO: invoiceOverviewDTO ?? this.invoiceOverviewDTO,
      // colors: colors ?? this.colors,
      listBankTypeDTO: listBankTypeDTO ?? this.listBankTypeDTO,
      isEmpty: isEmpty ?? this.isEmpty,
      isBankSelect: isBankSelect ?? this.isBankSelect,
      keyDTO: keyDTO ?? this.keyDTO,
    );
  }

  @override
  List<Object?> get props => [
        status,
        request,
        msg,
        bankAccount,
        // colors,
        listBanks,
        bankSelect,
        listTrans,
        overviewDto,
        invoiceOverviewDTO,
        typeQR,
        barCode,
        isEmpty,
        isBankSelect,
        keyDTO,
      ];
}
