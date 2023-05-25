import 'package:equatable/equatable.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class QRState extends Equatable {
  const QRState();

  @override
  List<Object?> get props => [];
}

class QRInitialState extends QRState {}

class QRGeneratedListSuccessfulState extends QRState {
  final List<QRGeneratedDTO> list;

  const QRGeneratedListSuccessfulState({required this.list});

  @override
  List<Object?> get props => [list];
}

class QRGenerateLoadingState extends QRState {}

class QRGeneratedSuccessfulState extends QRState {
  final QRGeneratedDTO dto;

  const QRGeneratedSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class QRGeneratedListFailedState extends QRState {}

class QRGeneratedFailedState extends QRState {}

class QRRegenerateLoadingState extends QRState {}

class QRRegeneratedSuccessState extends QRState {
  final bool newTransaction;
  final QRGeneratedDTO dto;

  const QRRegeneratedSuccessState({
    required this.newTransaction,
    required this.dto,
  });

  @override
  List<Object?> get props => [newTransaction, dto];
}

class QRRegeneratedFailedState extends QRState {}
