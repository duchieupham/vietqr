import 'package:equatable/equatable.dart';

class DetailStoreEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetTransStoreEvent extends DetailStoreEvent {
  final String subTerminalCode;
  final String value;
  final String fromDate;
  final String toDate;
  final int type;

  GetTransStoreEvent({
    this.fromDate = '',
    this.toDate = '',
    this.subTerminalCode = '',
    this.value = '',
    this.type = 9,
  });

  List<Object?> get props => [fromDate, toDate, subTerminalCode, value, type];
}

class FetchTransStoreEvent extends DetailStoreEvent {
  final String subTerminalCode;
  final String value;
  final String fromDate;
  final String toDate;
  final int type;

  FetchTransStoreEvent({
    this.fromDate = '',
    this.toDate = '',
    this.subTerminalCode = '',
    this.value = '',
    this.type = 9,
  });

  List<Object?> get props => [fromDate, toDate, subTerminalCode, value, type];
}

class GetDetailStoreEvent extends DetailStoreEvent {
  final String fromDate;
  final String toDate;

  GetDetailStoreEvent({this.fromDate = '', this.toDate = ''});

  List<Object?> get props => [fromDate, toDate];
}

class GetDetailQREvent extends DetailStoreEvent {}

class GetMembersStoreEvent extends DetailStoreEvent {
  GetMembersStoreEvent();

  List<Object?> get props => [];
}

class GetTerminalStoreEvent extends DetailStoreEvent {
  GetTerminalStoreEvent();

  List<Object?> get props => [];
}

class AddMemberGroup extends DetailStoreEvent {
  final String userId;
  final String terminalId;
  final String merchantId;

  AddMemberGroup({
    required this.userId,
    required this.terminalId,
    required this.merchantId,
  });

  @override
  List<Object?> get props => [userId, terminalId, merchantId];
}

class RemoveMemberEvent extends DetailStoreEvent {
  final String userId;

  RemoveMemberEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}
