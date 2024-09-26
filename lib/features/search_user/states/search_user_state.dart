import 'package:equatable/equatable.dart';

import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/detail_group_dto.dart';

enum SearchUserType {
  NONE,
  SEARCH_MEMBER,
  DELETE_MEMBER,
  CLEAR_MEMBER,
  INSERT_MEMBER,
  ERROR
}

class SearchUserState extends Equatable {
  final BlocStatus status;
  final String? msg;
  final SearchUserType request;
  final List<AccountMemberDTO> members;
  final List<AccountMemberDTO> insertMembers;
  final bool isLoading;
  final bool isEmpty;

  const SearchUserState({
    this.status = BlocStatus.NONE,
    this.msg,
    this.request = SearchUserType.NONE,
    required this.members,
    required this.insertMembers,
    this.isLoading = false,
    this.isEmpty = false,
  });

  SearchUserState copyWith({
    BlocStatus? status,
    SearchUserType? request,
    String? msg,
    List<AccountMemberDTO>? members,
    List<AccountMemberDTO>? insertMembers,
    bool? isLoading,
    bool? isEmpty,
  }) {
    return SearchUserState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      members: members ?? this.members,
      insertMembers: insertMembers ?? this.insertMembers,
      isLoading: isLoading ?? this.isLoading,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        request,
        members,
        isEmpty,
      ];
}
