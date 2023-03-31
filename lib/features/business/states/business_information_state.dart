import 'package:equatable/equatable.dart';
import 'package:vierqr/models/business_detail_dto.dart';
import 'package:vierqr/models/business_item_dto.dart';

class BusinessInformationState extends Equatable {
  const BusinessInformationState();

  @override
  List<Object?> get props => [];
}

class BusinessInformationInitialState extends BusinessInformationState {}

class BusinessInformationLoadingState extends BusinessInformationState {}

class BusinessInformationInsertSuccessfulState
    extends BusinessInformationState {}

class BusinessInformationInsertFailedState extends BusinessInformationState {
  final String msg;

  const BusinessInformationInsertFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class BusinessLoadingListState extends BusinessInformationState {}

class BusinessGetListSuccessfulState extends BusinessInformationState {
  final List<BusinessItemDTO> list;

  const BusinessGetListSuccessfulState({required this.list});

  @override
  List<Object?> get props => [list];
}

class BusinessGetListFailedState extends BusinessInformationState {}

class BusinessGetDetailLoadingState extends BusinessInformationState {}

class BusinessGetDetailSuccessState extends BusinessInformationState {
  final BusinessDetailDTO dto;

  const BusinessGetDetailSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BusinessGetDetailFailedState extends BusinessInformationState {}
