import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_account_remove_dto.dart';
import 'package:vierqr/models/bank_card_insert_dto.dart';
import 'package:vierqr/models/bank_card_insert_unauthenticated.dart';
import 'package:vierqr/models/bank_card_request_otp.dart';
import 'package:vierqr/models/bank_name_search_dto.dart';
import 'package:vierqr/models/confirm_otp_bank_dto.dart';
import 'package:vierqr/models/register_authentication_dto.dart';

class BankCardEvent extends Equatable {
  const BankCardEvent();

  @override
  List<Object?> get props => [];
}

class BankCardEventInsert extends BankCardEvent {
  final BankCardInsertDTO dto;

  const BankCardEventInsert({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankCardEventGetList extends BankCardEvent {
  final String userId;

  const BankCardEventGetList({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class BankCardEventRemove extends BankCardEvent {
  final BankAccountRemoveDTO dto;

  const BankCardEventRemove({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankCardEventRequestOTP extends BankCardEvent {
  final BankCardRequestOTP dto;

  const BankCardEventRequestOTP({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankCardEventConfirmOTP extends BankCardEvent {
  final ConfirmOTPBankDTO dto;

  const BankCardEventConfirmOTP({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankCardGetDetailEvent extends BankCardEvent {
  final bool isLoading;
  final bool isInit;

  const BankCardGetDetailEvent({this.isLoading = false, this.isInit = false});

  @override
  List<Object?> get props => [isLoading, isInit];
}

class BankCardCheckExistedEvent extends BankCardEvent {
  final String bankAccount;
  final String bankTypeId;

  const BankCardCheckExistedEvent({
    required this.bankAccount,
    required this.bankTypeId,
  });

  @override
  List<Object?> get props => [bankAccount, bankTypeId];
}

class BankCardEventInsertUnauthenticated extends BankCardEvent {
  final BankCardInsertUnauthenticatedDTO dto;

  const BankCardEventInsertUnauthenticated({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankCardEventRegisterAuthentication extends BankCardEvent {
  final RegisterAuthenticationDTO dto;

  const BankCardEventRegisterAuthentication({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class BankCardEventSearchName extends BankCardEvent {
  final BankNameSearchDTO dto;

  const BankCardEventSearchName({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankCardEventUnRequestOTP extends BankCardEvent {
  final String accountNumber;

  const BankCardEventUnRequestOTP({
    required this.accountNumber,
  });

  @override
  List<Object?> get props => [accountNumber];
}

class BankCardEventUnConfirmOTP extends BankCardEvent {
  final ConfirmOTPBankDTO dto;

  const BankCardEventUnConfirmOTP({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankCardEventUnLink extends BankCardEvent {
  final Map<String, dynamic> body;

  const BankCardEventUnLink({required this.body});

  @override
  List<Object?> get props => [body];
}

class UpdateEvent extends BankCardEvent {}

class BankCardGenerateDetailQR extends BankCardEvent {
  final Map<String, dynamic> dto;

  const BankCardGenerateDetailQR({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class GetMyListGroupEvent extends BankCardEvent {
  final String userID;
  final int offset;

  GetMyListGroupEvent({
    this.userID = '',
    this.offset = 0,
  });

  @override
  List<Object?> get props => [userID, offset];
}

class GetMerchantEvent extends BankCardEvent {}
