import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_account_remove_dto.dart';
import 'package:vierqr/models/bank_card_insert_dto.dart';
import 'package:vierqr/models/bank_card_request_otp.dart';

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
