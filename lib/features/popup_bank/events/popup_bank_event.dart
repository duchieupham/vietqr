import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_account_remove_dto.dart';
import 'package:vierqr/models/confirm_otp_bank_dto.dart';

class PopupBankEvent extends Equatable {
  const PopupBankEvent();

  @override
  List<Object?> get props => [];
}

class PopupBankEventRemove extends PopupBankEvent {
  final BankAccountRemoveDTO dto;

  PopupBankEventRemove(this.dto);

  @override
  List<Object?> get props => [dto];
}

class PopupBankEventUnlink extends PopupBankEvent {
  final String accountNumber;

  PopupBankEventUnlink(this.accountNumber);

  @override
  List<Object?> get props => [accountNumber];
}

class PopupBankEventUnConfirmOTP extends PopupBankEvent {
  final dynamic dto;
  final int unlinkType;

  PopupBankEventUnConfirmOTP(this.dto, this.unlinkType);

  @override
  List<Object?> get props => [dto, unlinkType];
}

class PopupBankEventUnRegisterBDSD extends PopupBankEvent {
  final String userId;
  final String bankId;

  PopupBankEventUnRegisterBDSD(this.userId, this.bankId);

  @override
  List<Object?> get props => [userId, bankId];
}

class UpdateBankAccountEvent extends PopupBankEvent {
  final BankAccountDTO dto;

  UpdateBankAccountEvent(this.dto);

  @override
  List<Object?> get props => [dto];
}
