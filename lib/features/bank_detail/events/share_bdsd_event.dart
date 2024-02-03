import 'package:equatable/equatable.dart';

class ShareBDSDEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetBusinessAvailDTOEvent extends ShareBDSDEvent {}

class ConnectBranchEvent extends ShareBDSDEvent {
  final String bankId;
  final String businessId;
  final String branchId;

  ConnectBranchEvent({
    required this.businessId,
    required this.branchId,
    required this.bankId,
  });

  @override
  List<Object?> get props => [businessId, branchId, bankId];
}

class GetMemberEvent extends ShareBDSDEvent {
  final String bankId;

  GetMemberEvent({
    this.bankId = '',
  });

  @override
  List<Object?> get props => [bankId];
}

class SearchMemberEvent extends ShareBDSDEvent {
  final String bankId;
  final String value;
  final int type;
  SearchMemberEvent({
    this.bankId = '',
    this.value = '',
    this.type = 0,
  });

  @override
  List<Object?> get props => [bankId, value, type];
}

class RemoveMemberEvent extends ShareBDSDEvent {
  final String bankId;
  final String userId;

  RemoveMemberEvent({
    required this.bankId,
    required this.userId,
  });

  @override
  List<Object?> get props => [bankId, userId];
}

class RemoveAllMemberEvent extends ShareBDSDEvent {
  final String bankId;

  RemoveAllMemberEvent({
    required this.bankId,
  });

  @override
  List<Object?> get props => [bankId];
}

class GetInfoTelegramEvent extends ShareBDSDEvent {
  final String? bankId;
  final bool isLoading;

  GetInfoTelegramEvent({this.bankId, this.isLoading = false});

  @override
  List<Object?> get props => [bankId, isLoading];
}

class GetInfoLarkEvent extends ShareBDSDEvent {
  final String? bankId;
  final bool isLoading;

  GetInfoLarkEvent({this.bankId, this.isLoading = false});

  @override
  List<Object?> get props => [bankId, isLoading];
}

class AddBankLarkEvent extends ShareBDSDEvent {
  final Map<String, dynamic> body;

  AddBankLarkEvent(this.body);

  @override
  List<Object?> get props => [body];
}

class AddBankTelegramEvent extends ShareBDSDEvent {
  final Map<String, dynamic> body;

  AddBankTelegramEvent(this.body);

  @override
  List<Object?> get props => [body];
}

class RemoveBankTelegramEvent extends ShareBDSDEvent {
  final Map<String, dynamic> body;

  RemoveBankTelegramEvent(this.body);

  @override
  List<Object?> get props => [body];
}

class RemoveBankLarkEvent extends ShareBDSDEvent {
  final Map<String, dynamic> body;

  RemoveBankLarkEvent(this.body);

  @override
  List<Object?> get props => [body];
}

class ShareUserBDSDEvent extends ShareBDSDEvent {
  final Map<String, dynamic> body;

  ShareUserBDSDEvent(this.body);

  @override
  List<Object?> get props => [body];
}

class GetListGroupBDSDEvent extends ShareBDSDEvent {
  final String userID;
  final int type;
  final int offset;

  GetListGroupBDSDEvent({this.userID = '', this.type = 0, this.offset = 0});

  @override
  List<Object?> get props => [userID, type, offset];
}
