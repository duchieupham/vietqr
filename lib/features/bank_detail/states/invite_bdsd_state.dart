import 'package:equatable/equatable.dart';
import 'package:vierqr/models/response_message_dto.dart';

class InviteBDSDState extends Equatable {
  const InviteBDSDState();

  @override
  List<Object?> get props => [];
}

class InviteBDSDInitialState extends InviteBDSDState {}

class InviteBDSDLoadingState extends InviteBDSDState {
  final bool isLoading;

  const InviteBDSDLoadingState({this.isLoading = false});

  @override
  List<Object?> get props => [isLoading];
}

class InviteBDSDGetRandomCodeSuccessState extends InviteBDSDState {
  final String data;
  final bool isLoading;

  const InviteBDSDGetRandomCodeSuccessState({
    required this.data,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [data, isLoading];
}

class InviteBDSDGetRandomCodeFailedState extends InviteBDSDState {}

class CreateNewGroupSuccessState extends InviteBDSDState {
  final ResponseMessageDTO dto;

  const CreateNewGroupSuccessState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class CreateNewGroupFailedState extends InviteBDSDState {
  final ResponseMessageDTO dto;

  const CreateNewGroupFailedState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class RemoveGroupSuccessState extends InviteBDSDState {
  final ResponseMessageDTO dto;

  const RemoveGroupSuccessState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class RemoveGroupFailedState extends InviteBDSDState {}

class UpdateGroupSuccessState extends InviteBDSDState {
  final ResponseMessageDTO dto;

  const UpdateGroupSuccessState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class UpdateGroupFailedState extends InviteBDSDState {
  final ResponseMessageDTO dto;

  const UpdateGroupFailedState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}
