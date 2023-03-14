import 'package:equatable/equatable.dart';
import 'package:vierqr/models/business_information_insert_dto.dart';

class BusinessInformationEvent extends Equatable {
  const BusinessInformationEvent();

  @override
  List<Object?> get props => [];
}

class BusinessInformationEventInsert extends BusinessInformationEvent {
  final BusinessInformationInsertDTO dto;

  const BusinessInformationEventInsert({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BusinessInformationEventGetList extends BusinessInformationEvent {
  final String userId;

  const BusinessInformationEventGetList({required this.userId});

  @override
  List<Object?> get props => [userId];
}
