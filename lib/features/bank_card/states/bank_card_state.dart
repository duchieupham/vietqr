import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_card_request_otp.dart';
import 'package:vierqr/models/bank_name_information_dto.dart';

class BankCardState extends Equatable {
  const BankCardState();

  @override
  List<Object?> get props => [];
}

class BankCardInitialState extends BankCardState {}

class BankCardLoadingState extends BankCardState {}

class BankCardRemoveLoadingState extends BankCardState {}

class BankCardLoadingListState extends BankCardState {}

class BankCardInsertSuccessfulState extends BankCardState {
  final String bankId;
  final String qr;

  const BankCardInsertSuccessfulState({required this.bankId, required this.qr});

  @override
  List<Object?> get props => [bankId, qr];
}

class BankCardInsertFailedState extends BankCardState {
  final String message;

  const BankCardInsertFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

class BankCardGetListSuccessState extends BankCardState {
  final List<BankAccountDTO> list;
  final List<Color> colors;

  const BankCardGetListSuccessState({
    required this.list,
    required this.colors,
  });

  @override
  List<Object?> get props => [list, colors];
}

class BankCardGetListFailedState extends BankCardState {
  final String message;

  const BankCardGetListFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

class BankCardRemoveSuccessState extends BankCardState {}

class BankCardRemoveFailedState extends BankCardState {
  final String message;

  const BankCardRemoveFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

//for request OTP
class BankCardReuqestOTPLoadingState extends BankCardState {}

class BankCardRequestOTPSuccessState extends BankCardState {
  final BankCardRequestOTP dto;
  final String requestId;

  const BankCardRequestOTPSuccessState({
    required this.dto,
    required this.requestId,
  });

  @override
  List<Object?> get props => [dto, requestId];
}

class BankCardRequestOTPFailedState extends BankCardState {
  final String message;

  const BankCardRequestOTPFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

//
class BankCardConfirmOTPLoadingState extends BankCardState {}

class BankCardConfirmOTPSuccessState extends BankCardState {}

class BankCardConfirmOTPFailedState extends BankCardState {
  final String message;

  const BankCardConfirmOTPFailedState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

//
class BankCardGetDetailLoadingState extends BankCardState {}

class BankCardGetDetailSuccessState extends BankCardState {
  final AccountBankDetailDTO dto;

  const BankCardGetDetailSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankCardGetDetailFailedState extends BankCardState {}

//
class BankCardInsertUnauthenticatedSuccessState extends BankCardState {
  final String bankId;
  final String qr;

  const BankCardInsertUnauthenticatedSuccessState({
    required this.bankId,
    required this.qr,
  });

  @override
  List<Object?> get props => [bankId, qr];
}

class BankCardInsertUnauthenticatedFailedState extends BankCardState {
  final String msg;

  const BankCardInsertUnauthenticatedFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class BankCardCheckExistedState extends BankCardState {
  final String msg;

  const BankCardCheckExistedState({
    required this.msg,
  });

  @override
  List<Object?> get props => [msg];
}

class BankCardCheckNotExistedState extends BankCardState {}

class BankCardCheckFailedState extends BankCardState {}

class BankCardUpdateAuthenticateSuccessState extends BankCardState {}

class BankCardUpdateAuthenticateFailedState extends BankCardState {
  final String msg;

  const BankCardUpdateAuthenticateFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class BankCardSearchingNameState extends BankCardState {}

class BankCardSearchNameSuccessState extends BankCardState {
  final BankNameInformationDTO dto;

  const BankCardSearchNameSuccessState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class BankCardSearchNameFailedState extends BankCardState {
  final String msg;

  const BankCardSearchNameFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}
