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

class PopupUnLinkBIDVEvent extends PopupBankEvent {
  final dynamic request;
  const PopupUnLinkBIDVEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class PopupBankEventUnlink extends PopupBankEvent {
  final String accountNumber;

  const PopupBankEventUnlink(this.accountNumber);

  @override
  List<Object?> get props => [accountNumber];
}

class PopupBankEventUnConfirmOTP extends PopupBankEvent {
  final dynamic dto;
  final int unlinkType;

  const PopupBankEventUnConfirmOTP(this.dto, this.unlinkType);

  @override
  List<Object?> get props => [dto];
}

class PopupBankEventUnRegisterBDSD extends PopupBankEvent {
  final String userId;
  final String bankId;

  const PopupBankEventUnRegisterBDSD(this.userId, this.bankId);

  @override
  List<Object?> get props => [userId, bankId];
}

class UpdateBankAccountEvent extends PopupBankEvent {
  final BankAccountDTO dto;

  const UpdateBankAccountEvent(this.dto);

  @override
  List<Object?> get props => [dto];
}
