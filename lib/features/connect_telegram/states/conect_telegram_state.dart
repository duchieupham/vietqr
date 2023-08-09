import 'package:equatable/equatable.dart';
import 'package:vierqr/models/info_tele_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class ConnectTelegramState extends Equatable {
  const ConnectTelegramState();

  @override
  List<Object?> get props => [];
}

class ConnectTelegramInitialState extends ConnectTelegramState {}

class ConnectTelegramLoadingState extends ConnectTelegramState {}

class InsertTeleSuccessState extends ConnectTelegramState {
  final ResponseMessageDTO dto;

  const InsertTeleSuccessState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class InsertTeleFailedState extends ConnectTelegramState {
  final ResponseMessageDTO dto;

  const InsertTeleFailedState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class GetInfoTeleConnectedSuccessState extends ConnectTelegramState {
  final List<InfoTeleDTO> list;

  const GetInfoTeleConnectedSuccessState({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}

class GetInfoTeleConnectedFailedState extends ConnectTelegramState {}

class GetInfoLoadingState extends ConnectTelegramState {}

class RemoveTelegramLoadingState extends ConnectTelegramState {}

class RemoveTeleSuccessState extends ConnectTelegramState {
  final ResponseMessageDTO dto;

  const RemoveTeleSuccessState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class RemoveTeleFailedState extends ConnectTelegramState {
  final ResponseMessageDTO dto;

  const RemoveTeleFailedState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}
