import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/models/account_bank_branch_dto.dart';
import 'package:vierqr/models/account_bank_connect_branch_dto.dart';
import 'package:vierqr/models/branch_filter_dto.dart';
import 'package:vierqr/models/branch_information_dto.dart';
import 'package:vierqr/models/business_branch_choice_dto.dart';
import 'package:vierqr/models/business_member_dto.dart';

class BranchState extends Equatable {
  const BranchState();

  @override
  List<Object?> get props => [];
}

class BranchInitialState extends BranchState {}

class BranchChoiceLoadingState extends BranchState {}

class BranchChoiceSuccessfulState extends BranchState {
  final List<BusinessBranchChoiceDTO> list;

  const BranchChoiceSuccessfulState({required this.list});

  @override
  List<Object?> get props => [list];
}

class BranchChoiceFailedState extends BranchState {}

class BranchGetFilterSuccessState extends BranchState {
  final List<BranchFilterDTO> list;

  const BranchGetFilterSuccessState({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}

class BranchGetFilterFailedState extends BranchState {}

class BranchDetailLoadingState extends BranchState {}

class BranchDetailSuccessState extends BranchState {
  final BranchInformationDTO dto;

  const BranchDetailSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BranchDetailFailedState extends BranchState {}

//

class BranchGetBanksLoadingState extends BranchState {}

class BranchGetBanksSuccessState extends BranchState {
  final List<AccountBankBranchDTO> list;
  final List<Color> colors;

  const BranchGetBanksSuccessState({required this.list, required this.colors});

  @override
  List<Object?> get props => [list, colors];
}

class BranchGetBanksFailedState extends BranchState {}

//

class BranchGetMembersLoadingState extends BranchState {}

class BranchGetMembersSuccessState extends BranchState {
  final List<BusinessMemberDTO> list;

  const BranchGetMembersSuccessState({required this.list});

  @override
  List<Object?> get props => [list];
}

class BranchGetMembersFailedState extends BranchState {}

//

class BranchSeachMemberLoadingState extends BranchState {}

class BranchSeachMemberSuccessState extends BranchState {
  final BusinessMemberDTO dto;

  const BranchSeachMemberSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BranchSearchMemberNotFoundState extends BranchState {
  final String message;

  const BranchSearchMemberNotFoundState({required this.message});

  @override
  List<Object?> get props => [message];
}

class BranchSeachMemberFailedState extends BranchState {}

//
class BranchInsertMemberLoadingState extends BranchState {}

class BranchInsertMemberSuccessState extends BranchState {}

class BranchInsertMemberFailedState extends BranchState {
  final String message;

  const BranchInsertMemberFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

//
class BranchDeleteMemberLoadingState extends BranchState {}

class BranchDeleteMemberSuccessState extends BranchState {}

class BranchDeleteMemberFailedState extends BranchState {
  final String message;

  const BranchDeleteMemberFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

//
class BranchGetConnectBankLoadingState extends BranchState {}

class BranchGetConnectBankSuccessState extends BranchState {
  final List<AccountBankConnectBranchDTO> list;
  final List<Color> colors;

  const BranchGetConnectBankSuccessState(
      {required this.list, required this.colors});

  @override
  List<Object?> get props => [list, colors];
}

class BranchGetConnectBankFailedState extends BranchState {
  final String message;

  const BranchGetConnectBankFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

//
class BranchConnectBankLoadingState extends BranchState {}

class BranchConnectBankSuccessState extends BranchState {}

class BranchConnectBankFailedState extends BranchState {
  final String message;

  const BranchConnectBankFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

//
class BranchRemoveBankLoadingState extends BranchState {}

class BranchRemoveBankSuccessState extends BranchState {}

class BranchRemoveBankFailedState extends BranchState {
  final String message;

  const BranchRemoveBankFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}
