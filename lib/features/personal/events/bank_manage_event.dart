import 'package:vierqr/models/bank_account_dto.dart';
import 'package:equatable/equatable.dart';

class BankManageEvent extends Equatable {
  const BankManageEvent();
  @override
  List<Object> get props => [];
}

class BankManageEventGetList extends BankManageEvent {
  final String userId;
  const BankManageEventGetList({required this.userId});
  @override
  List<Object> get props => [userId];
}

class BankManageEventAddDTO extends BankManageEvent {
  final String userId;
  final String phoneNo;
  final BankAccountDTO dto;

  const BankManageEventAddDTO({
    required this.userId,
    required this.phoneNo,
    required this.dto,
  });

  @override
  List<Object> get props => [dto];
}

class BankManageEventRemoveDTO extends BankManageEvent {
  final String userId;
  final String bankCode;
  final String bankId;

  const BankManageEventRemoveDTO(
      {required this.userId, required this.bankCode, required this.bankId});

  @override
  List<Object> get props => [userId, bankCode, bankId];
}

class BankManageEventGetDTO extends BankManageEvent {
  final String userId;
  final String bankAccount;

  const BankManageEventGetDTO(
      {required this.userId, required this.bankAccount});

  @override
  List<Object> get props => [userId, bankAccount];
}

class BankManageEventGetAccountBalance extends BankManageEvent {
  final String customerId;
  final String accountNumber;

  const BankManageEventGetAccountBalance({
    required this.customerId,
    required this.accountNumber,
  });

  @override
  List<Object> get props => [customerId, accountNumber];
}
