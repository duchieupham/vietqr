import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_account_dto.dart';

class EmailEvent extends Equatable {
  const EmailEvent();

  @override
  List<Object?> get props => [];
}

class SendOTPEvent extends EmailEvent {
  final Map<String, dynamic> param;
  const SendOTPEvent({required this.param});

  @override
  List<Object?> get props => [param];
}

class SendOTPAgainEvent extends EmailEvent {
  final Map<String, dynamic> param;
  const SendOTPAgainEvent({required this.param});

  @override
  List<Object?> get props => [param];
}

class ConfirmOTPEvent extends EmailEvent {
  final Map<String, dynamic> param;
  const ConfirmOTPEvent({required this.param});

  @override
  List<Object?> get props => [param];
}


class GetKeyFreeEvent extends EmailEvent {
  final Map<String, dynamic> param;
  final BankAccountDTO dto;
  const GetKeyFreeEvent({required this.param, required this.dto});

  @override
  List<Object?> get props => [param];
}
