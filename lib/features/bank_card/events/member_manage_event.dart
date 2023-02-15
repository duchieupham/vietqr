import 'package:equatable/equatable.dart';

class MemberManageEvent extends Equatable {
  const MemberManageEvent();

  @override
  List<Object?> get props => [];
}

class MemberManageEventAdd extends MemberManageEvent {
  final String bankId;
  final String phoneNo;
  final String role;

  const MemberManageEventAdd(
      {required this.bankId, required this.phoneNo, required this.role});

  @override
  List<Object?> get props => [bankId, phoneNo, role];
}

class MemberManageEventRemove extends MemberManageEvent {
  final String bankId;
  final String userId;

  const MemberManageEventRemove({required this.bankId, required this.userId});

  @override
  List<Object?> get props => [bankId, userId];
}

class MemberManageEventGetList extends MemberManageEvent {
  final String bankId;

  const MemberManageEventGetList({required this.bankId});

  @override
  List<Object?> get props => [bankId];
}
