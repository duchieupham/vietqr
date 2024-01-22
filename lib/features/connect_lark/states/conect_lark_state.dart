import 'package:equatable/equatable.dart';
import 'package:vierqr/models/info_tele_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class ConnectLarkState extends Equatable {
  const ConnectLarkState();

  @override
  List<Object?> get props => [];
}

class ConnectLarkInitialState extends ConnectLarkState {}

class ConnectLarkLoadingState extends ConnectLarkState {}

class InsertLarkSuccessState extends ConnectLarkState {
  final ResponseMessageDTO dto;

  const InsertLarkSuccessState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class InsertLarkFailedState extends ConnectLarkState {
  final ResponseMessageDTO dto;

  const InsertLarkFailedState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class GetInfoLarkConnectedSuccessState extends ConnectLarkState {
  final List<InfoLarkDTO> list;

  const GetInfoLarkConnectedSuccessState({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}

class GetInfoLarkConnectedFailedState extends ConnectLarkState {}

class GetInfoLoadingState extends ConnectLarkState {}

class RemoveLarkConnectLoadingState extends ConnectLarkState {}

class RemoveLarkSuccessState extends ConnectLarkState {
  final ResponseMessageDTO dto;

  const RemoveLarkSuccessState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class RemoveLarkFailedState extends ConnectLarkState {
  final ResponseMessageDTO dto;

  const RemoveLarkFailedState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class RemoveBankLarkSuccessState extends ConnectLarkState {
  final ResponseMessageDTO dto;

  const RemoveBankLarkSuccessState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class RemoveBankLarkFailedState extends ConnectLarkState {
  final ResponseMessageDTO dto;

  const RemoveBankLarkFailedState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class AddBankLarkSuccessState extends ConnectLarkState {
  final ResponseMessageDTO dto;

  const AddBankLarkSuccessState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class AddBankLarkFailedState extends ConnectLarkState {
  final ResponseMessageDTO dto;

  const AddBankLarkFailedState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}
