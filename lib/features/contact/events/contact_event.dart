import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:vierqr/models/add_contact_dto.dart';
import 'package:vierqr/models/contact_dto.dart';

class ContactEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitDataEvent extends ContactEvent {}

class ContactEventGetList extends ContactEvent {
  final int? type;
  final int? offset;
  final bool isLoading;
  final bool isLoadMore;

  ContactEventGetList({
    this.type,
    this.offset,
    this.isLoading = true,
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [type, offset];
}

class GetListContactLoadMore extends ContactEvent {
  final int? type;
  final int? offset;
  final bool isLoading;
  final bool isLoadMore;

  GetListContactLoadMore({
    this.type,
    this.offset,
    this.isLoading = true,
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [type, offset];
}

class ContactEventGetListRecharge extends ContactEvent {}

class ContactEventGetListPending extends ContactEvent {}

class ContactEventGetDetail extends ContactEvent {
  final String id;
  final int type;
  final bool isChange;

  ContactEventGetDetail(
      {required this.id, required this.type, this.isChange = false});

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
  final File? image;

  UpdateContactEvent(this.query, this.image);

  @override
  List<Object?> get props => [query];
}

class UpdateContactRelationEvent extends ContactEvent {
  final Map<String, dynamic> query;

  UpdateContactRelationEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class SaveContactEvent extends ContactEvent {
  final AddContactDTO dto;
  final File? file;

  SaveContactEvent({
    required this.dto,
    this.file,
  });

  @override
  List<Object?> get props => [dto, file];
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

class UpdateEventContact extends ContactEvent {}

class SearchUser extends ContactEvent {
  final String phoneNo;

  SearchUser(this.phoneNo);

  @override
  List<Object?> get props => [phoneNo];
}

class InsertVCardEvent extends ContactEvent {
  final List<VCardModel> list;

  InsertVCardEvent(this.list);

  @override
  List<Object?> get props => [list];
}

class UpdateContactVCardEvent extends ContactEvent {
  final Map<String, dynamic> query;
  final File? image;

  UpdateContactVCardEvent(this.query, this.image);

  @override
  List<Object?> get props => [query];
}

class SearchContactEvent extends ContactEvent {
  final int? type;
  final int? offset;
  final String? nickName;

  SearchContactEvent({
    this.type,
    this.offset,
    this.nickName,
  });

  @override
  List<Object?> get props => [type, offset];
}
