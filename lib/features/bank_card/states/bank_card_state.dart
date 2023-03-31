import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_card_request_otp.dart';

class BankCardState extends Equatable {
  const BankCardState();

  @override
  List<Object?> get props => [];
}

class BankCardInitialState extends BankCardState {}

class BankCardLoadingState extends BankCardState {}

class BankCardInsertSuccessfulState extends BankCardState {}

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
class BankCardInsertUnauthenticatedSuccessState extends BankCardState {}

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
