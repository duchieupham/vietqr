import 'package:equatable/equatable.dart';
import 'package:vierqr/models/user_bank_dto.dart';

class MemberManageState extends Equatable {
  const MemberManageState();

  @override
  List<Object?> get props => [];
}

class MemberManageInitialState extends MemberManageState {}

class MemberManageLoadingState extends MemberManageState {}

class MemberManageAddingState extends MemberManageState {}

class MemberManageRemovingState extends MemberManageState {}

class MemberManageGetListSuccessState extends MemberManageState {
  final List<UserBankDTO> users;

  const MemberManageGetListSuccessState({required this.users});

  @override
  List<Object?> get props => [users];
}

class MemberManageAddSuccessfulState extends MemberManageState {}

class MemberManageRemoveSuccessState extends MemberManageState {}

class MemberManageGetListFailedState extends MemberManageState {}

class MemberManageAddFailedStateState extends MemberManageState {}

class MemberManageRemoveFailedState extends MemberManageState {}
