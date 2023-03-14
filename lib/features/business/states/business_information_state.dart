import 'package:equatable/equatable.dart';
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
