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

class GetMoreQrPrivateEvent extends QrFeedEvent {
  final String value;
  final int type;
  final int? size;
  final int? page;

  const GetMoreQrPrivateEvent({
    required this.value,
    required this.type,
    this.size,
    this.page,
  });

  @override
  List<Object?> get props => [
        value,
        type,
        size,
        page,
      ];
}

class GetQrFeedPrivateEvent extends QrFeedEvent {
  final String value;

  final int type;
  final bool isGetFolder;
  final bool isFolderLoading;
  final int? size;
  final int? page;
  final int? folderSize;
  final int? folderPage;

  const GetQrFeedPrivateEvent({
    required this.value,
    required this.type,
    required this.isGetFolder,
    this.size,
    this.page,
    this.folderSize,
    this.folderPage,
    this.isFolderLoading = false,
  });

  @override
  List<Object?> get props => [
        value,
        type,
        isGetFolder,
        isFolderLoading,
        size,
        page,
        folderSize,
        folderPage
      ];
}

class GetMoreQrFeedFolderEvent extends QrFeedEvent {
  final String value;
  final int type;
  final int? size;
  final int? page;

  const GetMoreQrFeedFolderEvent({
    required this.value,
    required this.type,
    this.size,
    this.page,
  });

  @override
  List<Object?> get props => [value, type, size, page];
}

class GetQrFeedFolderEvent extends QrFeedEvent {
  final String value;
  final int type;
  final int? size;
  final int? page;

  const GetQrFeedFolderEvent({
    required this.value,
    required this.type,
    this.size,
    this.page,
  });

  @override
  List<Object?> get props => [value, type, size, page];
}

class GetQrFeedDetailEvent extends QrFeedEvent {
  final String id;
  final bool isLoading;
  final int? size;
  final int? page;

  const GetQrFeedDetailEvent(
      {required this.id, required this.isLoading, this.size, this.page});

  @override
  List<Object?> get props => [id, isLoading, size, page];
}

class GetQrFeedPopupDetailEvent extends QrFeedEvent {
  final String qrWalletId;

  const GetQrFeedPopupDetailEvent({required this.qrWalletId});

  @override
  List<Object?> get props => [qrWalletId];
}

class AddCommendEvent extends QrFeedEvent {
  final String qrWalletId;
  final String message;
  final int? size;
  final int? page;

  const AddCommendEvent(
      {required this.qrWalletId, required this.message, this.size, this.page});

  @override
  List<Object?> get props => [qrWalletId, message, page, size];
}

class LoadConmmentEvent extends QrFeedEvent {
  final String id;
  final bool isLoading;
  final bool isLoadMore;

  final int? size;
  final int? page;

  const LoadConmmentEvent(
      {required this.id,
      required this.isLoadMore,
      required this.isLoading,
      this.size,
      this.page});

  @override
  List<Object?> get props => [id, isLoadMore, isLoading, size, page];
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
