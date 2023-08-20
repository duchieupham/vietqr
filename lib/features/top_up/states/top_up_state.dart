import 'package:equatable/equatable.dart';
import 'package:vierqr/models/respone_top_up_dto.dart';

class TopUpState extends Equatable {
  const TopUpState();

  @override
  List<Object?> get props => [];
}

class TopUpInitialState extends TopUpState {}

class TopUpLoadingState extends TopUpState {}

class TopUpCreateQrSuccessState extends TopUpState {
  final ResponseTopUpDTO dto;

  const TopUpCreateQrSuccessState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class TopUpCreateQrFailedState extends TopUpState {}
