import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:vierqr/features/qr_feed/views/create_folder_screen.dart';
import 'package:vierqr/features/qr_feed/views/qr_screen.dart';
import 'package:vierqr/models/bank_name_search_dto.dart';
import 'package:vierqr/models/create_folder_dto.dart';
import 'package:vierqr/models/qr_create_type_dto.dart';
import 'package:vierqr/models/user_folder_dto.dart';

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

class GetUserQREvent extends QrFeedEvent {
  final String value;
  final int type;
  final int? size;
  final int? page;

  const GetUserQREvent({
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

class DeleteQrCodesEvent extends QrFeedEvent {
  final List<String>? qrIds;

  const DeleteQrCodesEvent({
    required this.qrIds,
  });

  @override
  List<Object?> get props => [qrIds];
}

class DeleteFolderEvent extends QrFeedEvent {
  final String folderId;
  final int deleteItems;

  const DeleteFolderEvent({required this.folderId, required this.deleteItems});

  @override
  List<Object?> get props => [folderId, deleteItems];
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

class GetMoreUserFolderEvent extends QrFeedEvent {
  final String value;
  final String folderId;
  final int? size;
  final int? page;

  const GetMoreUserFolderEvent({
    required this.value,
    required this.folderId,
    this.size,
    this.page,
  });

  @override
  List<Object?> get props => [value, folderId, size, page];
}

class UpdateUserRoleFolderEvent extends QrFeedEvent {
  final String folderId;
  final String userFolderId;
  final String role;

  const UpdateUserRoleFolderEvent({
    required this.folderId,
    required this.userFolderId,
    required this.role,
  });
  @override
  List<Object?> get props => [folderId, userFolderId, role];
}

class RemoveUserFolderEvent extends QrFeedEvent {
  final String folderId;
  final String userFolderId;

  const RemoveUserFolderEvent({
    required this.folderId,
    required this.userFolderId,
  });
  @override
  List<Object?> get props => [folderId, userFolderId];
}

class GetUserFolderEvent extends QrFeedEvent {
  final String value;
  final String folderId;
  final int? size;
  final int? page;
  final bool isLoading;

  const GetUserFolderEvent({
    required this.value,
    required this.folderId,
    required this.isLoading,
    this.size,
    this.page,
  });

  @override
  List<Object?> get props => [value, folderId, size, page, isLoading];
}

class UpdateQREvent extends QrFeedEvent {
  final TypeQr type;
  final dynamic data;

  const UpdateQREvent({required this.type, required this.data});

  @override
  List<Object?> get props => [type, data];
}

class CreateFolderEvent extends QrFeedEvent {
  final CreateFolderDTO dto;

  const CreateFolderEvent({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class GetFolderDetailEvent extends QrFeedEvent {
  final String value;
  final String folderId;
  final int type;
  final bool isLoading;

  const GetFolderDetailEvent({
    required this.value,
    required this.folderId,
    required this.type,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [value, type, folderId, isLoading];
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

class UpdateFolderTitleEvent extends QrFeedEvent {
  final String title;
  final String description;
  final String folderId;

  const UpdateFolderTitleEvent({
    required this.title,
    required this.description,
    required this.folderId,
  });

  @override
  List<Object?> get props => [title, folderId, description];
}

class RemoveQRFolderEvent extends QrFeedEvent {
  final dynamic data;

  const RemoveQRFolderEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class UpdateQRFolderEvent extends QrFeedEvent {
  final dynamic data;

  const UpdateQRFolderEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetQrFeedDetailEvent extends QrFeedEvent {
  final String folderId;

  final String id;
  final bool isLoading;
  final int? size;
  final int? page;

  const GetQrFeedDetailEvent(
      {required this.id,
      required this.isLoading,
      this.folderId = '',
      this.size,
      this.page});

  @override
  List<Object?> get props => [id, folderId, isLoading, size, page];
}

class GetQRFolderEvent extends QrFeedEvent {
  final String folderId;
  final int? page;
  final int? size;
  final int addedToFolder;

  const GetQRFolderEvent({
    required this.folderId,
    this.page,
    this.size,
    required this.addedToFolder,
  });

  @override
  List<Object?> get props => [folderId, addedToFolder, size, page];
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

class AddUserToFolderEvent extends QrFeedEvent {
  final String folderId;
  final List<UserFolder> userRoles;

  const AddUserToFolderEvent({
    required this.folderId,
    required this.userRoles,
  });

  @override
  List<Object?> get props => [folderId, userRoles];
}

class GetUpdateFolderDetailEvent extends QrFeedEvent {
  final ActionType type;
  final String folderId;
  final int? addedFolder;

  const GetUpdateFolderDetailEvent(
      {required this.type, required this.folderId, this.addedFolder});

  @override
  List<Object?> get props => [type, folderId, addedFolder];
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
