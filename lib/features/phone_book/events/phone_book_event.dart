import 'package:equatable/equatable.dart';

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

class PhoneBookEventUpdate extends PhoneBookEvent {
  final Map<String, dynamic> data;
  PhoneBookEventUpdate({required this.data});
  @override
  List<Object?> get props => [data];
}
