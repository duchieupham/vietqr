import 'package:equatable/equatable.dart';
import 'package:vierqr/models/business_member_dto.dart';

class BusinessMemberState extends Equatable {
  const BusinessMemberState();

  @override
  List<Object?> get props => [];
}

class BusinessMemberInitialState extends BusinessMemberState {}

class BusinessMemberLoadingState extends BusinessMemberInitialState {}

class BusinessMemberSearchNotFoundState extends BusinessMemberState {
  final String message;

  const BusinessMemberSearchNotFoundState({required this.message});

  @override
  List<Object?> get props => [message];
}

class BusinessMemberSearchState extends BusinessMemberState {
  final BusinessMemberDTO dto;

  const BusinessMemberSearchState({required this.dto});

  @override
  List<Object?> get props => [dto];
}
