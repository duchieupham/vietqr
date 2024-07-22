import 'package:equatable/equatable.dart';
import 'package:vierqr/models/response_message_dto.dart';

class EmailState extends Equatable {
  const EmailState();

  @override
  List<Object?> get props => [];
}

class EmailInitialState extends EmailState {}

class EmailLoadingState extends EmailState {}

class EmailLoadingActiveFeeState extends EmailState {}

class EmailLoadingInitState extends EmailState {}

class SendOTPState extends EmailState {}

class SendOTPSuccessfulState extends EmailState {}

class SendOTPFailedState extends EmailState {
  final ResponseMessageDTO dto;

  const SendOTPFailedState({required this.dto});

  @override
  List<Object?> get props => [dto];
}
