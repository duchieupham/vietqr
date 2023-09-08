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
  final String? branchId;
  final String? businessId;

  GetMemberEvent({
    this.branchId,
    this.businessId,
  });

  @override
  List<Object?> get props => [branchId, businessId];
}

class DeleteMemberEvent extends ShareBDSDEvent {
  final String businessId;
  final String userId;

  DeleteMemberEvent({
    required this.businessId,
    required this.userId,
  });

  @override
  List<Object?> get props => [businessId, userId];
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
