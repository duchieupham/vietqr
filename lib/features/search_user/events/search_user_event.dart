import 'package:equatable/equatable.dart';
import 'package:vierqr/models/detail_group_dto.dart';

class SearchUserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDataSearchUser extends SearchUserEvent {}

class SearchMemberEvent extends SearchUserEvent {
  final String terminalId;
  final String value;
  final int type;

  SearchMemberEvent({
    this.terminalId = '',
    this.value = '',
    this.type = 0,
  });

  @override
  List<Object?> get props => [terminalId, value, type];
}

class UpdateMembersEvent extends SearchUserEvent {
  UpdateMembersEvent();
}

class InsertMemberToList extends SearchUserEvent {
  final AccountMemberDTO dto;

  InsertMemberToList(this.dto);

  @override
  List<Object?> get props => [dto];
}

class ShareUserBDSDEvent extends SearchUserEvent {
  final Map<String, dynamic> body;

  ShareUserBDSDEvent(this.body);

  @override
  List<Object?> get props => [body];
}
