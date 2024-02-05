import 'package:equatable/equatable.dart';
import 'package:vierqr/models/detail_group_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class DetailGroupState extends Equatable {
  const DetailGroupState();

  @override
  List<Object?> get props => [];
}

class DetailGroupInitialState extends DetailGroupState {}

class DetailGroupLoadingState extends DetailGroupState {}

class DetailGroupLoadingPageState extends DetailGroupState {}

class DetailGroupSuccessState extends DetailGroupState {
  final GroupDetailDTO data;
  const DetailGroupSuccessState({
    required this.data,
  });

  @override
  List<Object?> get props => [data];
}

class DetailGroupFailedState extends DetailGroupState {}

class RemoveMemberSuccessState extends DetailGroupState {
  final ResponseMessageDTO dto;
  const RemoveMemberSuccessState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class RemoveMemberFailedState extends DetailGroupState {}

class AddMemberSuccessState extends DetailGroupState {}

class AddMemberFailedState extends DetailGroupState {}

class AddBankToGroupSuccessState extends DetailGroupState {}

class AddBankToGroupFailedState extends DetailGroupState {}

class RemoveBankToGroupSuccessState extends DetailGroupState {}

class RemoveBankToGroupFailedState extends DetailGroupState {}
