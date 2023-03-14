import 'package:equatable/equatable.dart';

class BusinessMemberEvent extends Equatable {
  const BusinessMemberEvent();

  @override
  List<Object?> get props => [];
}

class BusinessMemberEventInitial extends BusinessMemberEvent {}

class BusinessMemberEventSearch extends BusinessMemberEvent {
  final String phone;

  const BusinessMemberEventSearch({required this.phone});

  @override
  List<Object?> get props => [phone];
}
