import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_card_insert_dto.dart';
import 'package:vierqr/models/bank_card_insert_unauthenticated.dart';
import 'package:vierqr/models/bank_card_request_otp.dart';
import 'package:vierqr/models/bank_name_search_dto.dart';
import 'package:vierqr/models/confirm_otp_bank_dto.dart';
import 'package:vierqr/models/register_authentication_dto.dart';

class AddBankEvent extends Equatable {
  const AddBankEvent();

  @override
  List<Object?> get props => [];
}

class LoadDataBankEvent extends AddBankEvent {
  final bool isLoading;

  const LoadDataBankEvent({this.isLoading = true});
}

class ChangeAccountBankEvent extends AddBankEvent {
  final String value;

  const ChangeAccountBankEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class ChangeNameEvent extends AddBankEvent {
  final String value;

  const ChangeNameEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class BankCardEventSearchName extends AddBankEvent {
  final BankNameSearchDTO dto;

  const BankCardEventSearchName({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class UpdateAddBankEvent extends AddBankEvent {}

class BankCardCheckExistedEvent extends AddBankEvent {
  final String bankAccount;
  final String bankTypeId;

  const BankCardCheckExistedEvent({
    required this.bankAccount,
    required this.bankTypeId,
  });

  @override
  List<Object?> get props => [bankAccount, bankTypeId];
}

class BankCardEventInsertUnauthenticated extends AddBankEvent {
  final BankCardInsertUnauthenticatedDTO dto;

  const BankCardEventInsertUnauthenticated({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankCardEventRequestOTP extends AddBankEvent {
  final BankCardRequestOTP dto;

  const BankCardEventRequestOTP({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankCardEventConfirmOTP extends AddBankEvent {
  final ConfirmOTPBankDTO dto;

  const BankCardEventConfirmOTP({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankCardEventInsert extends AddBankEvent {
  final BankCardInsertDTO dto;

  const BankCardEventInsert({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankCardEventRegisterLinkBank extends AddBankEvent {
  final RegisterAuthenticationDTO dto;

  const BankCardEventRegisterLinkBank({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class ScanQrEventGetBankType extends AddBankEvent {
  final String code;

  const ScanQrEventGetBankType({required this.code});

  @override
  List<Object?> get props => [code];
}
