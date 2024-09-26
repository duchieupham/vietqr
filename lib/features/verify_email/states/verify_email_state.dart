import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/key_free_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class EmailState extends Equatable {
  const EmailState();

  @override
  List<Object?> get props => [];
}

class EmailInitialState extends EmailState {}

class EmailLoadingState extends EmailState {}

class EmailLoadingActiveFeeState extends EmailState {}

class EmailLoadingInitState extends EmailState {}

class SendOTPState extends EmailState {}

class SendOTPSuccessfulState extends EmailState {}

class SendOTPFailedState extends EmailState {
  final ResponseMessageDTO dto;

  const SendOTPFailedState({required this.dto});

  @override
  List<Object?> get props => [dto];
}


class SendOTPAgainState extends EmailState {}

class SendOTPAgainSuccessfulState extends EmailState {}

class SendOTPAgainFailedState extends EmailState {
  final ResponseMessageDTO dto;

  const SendOTPAgainFailedState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class ConfirmOTPState extends EmailState {}

class ConfirmOTPStateSuccessfulState extends EmailState {}

class ConfirmOTPStateFailedState extends EmailState {
  final ResponseMessageDTO dto;

  const ConfirmOTPStateFailedState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class ConfirmOTPStateFailedTimeOutState extends EmailState {
  final ResponseMessageDTO dto;

  const ConfirmOTPStateFailedTimeOutState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class GetKeyFreeState extends EmailState {}

class GetKeyFreeSuccessfulState extends EmailState {
  final KeyFreeDTO keyFreeDTO;
  final BankAccountDTO dto;

  const GetKeyFreeSuccessfulState(
      {required this.keyFreeDTO, required this.dto});
}

class GetKeyFreeFailedState extends EmailState {
  final KeyFreeDTO keyFreeDTO;

  const GetKeyFreeFailedState({required this.keyFreeDTO});
}
