import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_name_search_dto.dart';
import 'package:vierqr/models/qr_create_type_dto.dart';

class QrFeedEvent extends Equatable {
  const QrFeedEvent();

  @override
  List<Object?> get props => [];
}

class GetQrFeedEvent extends QrFeedEvent {
  final int type;
  final bool isLoading;
  final int? size;
  final int? page;

  const GetQrFeedEvent(
      {required this.type, required this.isLoading, this.size, this.page});

  @override
  List<Object?> get props => [type, isLoading, size, page];
}

class GetMoreQrFeedEvent extends QrFeedEvent {
  final int type;

  const GetMoreQrFeedEvent({required this.type});

  @override
  List<Object?> get props => [type];
}

class LoadBanksEvent extends QrFeedEvent {}

class CreateQrFeedLink extends QrFeedEvent {
  final QrCreateFeedDTO dto;
  final File? file;

  const CreateQrFeedLink({required this.dto, this.file});

  @override
  List<Object?> get props => [dto, file];
}

class SearchBankEvent extends QrFeedEvent {
  final BankNameSearchDTO dto;

  const SearchBankEvent({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class InteractWithQrEvent extends QrFeedEvent {
  final String? qrWalletId;
  final String? interactionType;

  const InteractWithQrEvent({required this.qrWalletId, this.interactionType});

  @override
  List<Object?> get props => [qrWalletId, interactionType];
}
