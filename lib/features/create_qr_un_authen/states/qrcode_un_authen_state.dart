import 'package:equatable/equatable.dart';

import '../../../models/bank_type_dto.dart';
import '../../../models/qr_generated_dto.dart';

class QRCodeUnUTState extends Equatable {
  const QRCodeUnUTState();

  @override
  List<Object?> get props => [];
}

class CreateInitialState extends QRCodeUnUTState {}

class CreateQRLoadingState extends QRCodeUnUTState {}

class CreateSuccessfulState extends QRCodeUnUTState {
  final QRGeneratedDTO dto;

  const CreateSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class CreateFailedState extends QRCodeUnUTState {}

class GetBankTYpeLoadingState extends QRCodeUnUTState {}

class GetBankTYpeErrorState extends QRCodeUnUTState {}

class GetBankTYpeSuccessState extends QRCodeUnUTState {
  final List<BankTypeDTO> list;

  const GetBankTYpeSuccessState({required this.list});

  @override
  List<Object?> get props => [list];
}
