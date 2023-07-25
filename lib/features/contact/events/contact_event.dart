import 'package:equatable/equatable.dart';
import 'package:vierqr/models/add_contact_dto.dart';

class ContactEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContactEventGetList extends ContactEvent {}

class ContactEventGetListPending extends ContactEvent {}

class ContactEventGetDetail extends ContactEvent {
  final String id;

  ContactEventGetDetail({required this.id});

  @override
  List<Object?> get props => [id];
}

class RemoveContactEvent extends ContactEvent {
  final String id;

  RemoveContactEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class UpdateContactEvent extends ContactEvent {
  final Map<String, dynamic> query;

  UpdateContactEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class SaveContactEvent extends ContactEvent {
  final AddContactDTO dto;

  SaveContactEvent({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class ScanQrContactEvent extends ContactEvent {
  final String code;

  ScanQrContactEvent(this.code);

  @override
  List<Object?> get props => [code];
}

class UpdateStatusContactEvent extends ContactEvent {
  final Map<String, dynamic> query;

  UpdateStatusContactEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class GetNickNameContactEvent extends ContactEvent {}

class UpdateEvent extends ContactEvent {}
