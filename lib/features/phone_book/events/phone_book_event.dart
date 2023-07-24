import 'package:equatable/equatable.dart';
import 'package:vierqr/models/add_phone_book_dto.dart';

class PhoneBookEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PhoneBookEventGetList extends PhoneBookEvent {}

class PhoneBookEventGetListPending extends PhoneBookEvent {}

class PhoneBookEventGetDetail extends PhoneBookEvent {
  final String id;

  PhoneBookEventGetDetail({required this.id});

  @override
  List<Object?> get props => [id];
}

class RemovePhoneBookEvent extends PhoneBookEvent {
  final String id;

  RemovePhoneBookEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class UpdatePhoneBookEvent extends PhoneBookEvent {
  final Map<String, dynamic> query;

  UpdatePhoneBookEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class SavePhoneBookEvent extends PhoneBookEvent {
  final AddPhoneBookDTO dto;

  SavePhoneBookEvent({required this.dto});

  @override
  List<Object?> get props => [dto];
}
