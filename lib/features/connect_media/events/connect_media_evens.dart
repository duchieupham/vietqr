import 'package:equatable/equatable.dart';
import 'package:vierqr/features/connect_media/connect_media_screen.dart';

class ConnectMediaEvent extends Equatable {
  const ConnectMediaEvent();

  @override
  List<Object?> get props => [];
}

class GetListGGSheetEvent extends ConnectMediaEvent {
  final int page;
  final int size;
  final bool isLoadMore;

  const GetListGGSheetEvent({
    required this.page,
    required this.size,
    required this.isLoadMore,
  });

  @override
  List<Object?> get props => [page, size, isLoadMore];
}

class GetListSlackEvent extends ConnectMediaEvent {
  final int page;
  final int size;
  final bool isLoadMore;

  const GetListSlackEvent({
    required this.page,
    required this.size,
    required this.isLoadMore,
  });

  @override
  List<Object?> get props => [page, size, isLoadMore];
}

class GetListDiscordEvent extends ConnectMediaEvent {
  final int page;
  final int size;
  final bool isLoadMore;

  const GetListDiscordEvent({
    required this.page,
    required this.size,
    required this.isLoadMore,
  });

  @override
  List<Object?> get props => [page, size, isLoadMore];
}

class GetListGGChatEvent extends ConnectMediaEvent {
  final int page;
  final int size;
  final bool isLoadMore;

  const GetListGGChatEvent({
    required this.page,
    required this.size,
    required this.isLoadMore,
  });

  @override
  List<Object?> get props => [page, size, isLoadMore];
}

class GetListTeleEvent extends ConnectMediaEvent {
  final int page;
  final int size;
  final bool isLoadMore;

  const GetListTeleEvent({
    required this.page,
    required this.size,
    required this.isLoadMore,
  });

  @override
  List<Object?> get props => [page, size, isLoadMore];
}

class GetListLarkEvent extends ConnectMediaEvent {
  final int page;
  final int size;
  final bool isLoadMore;

  const GetListLarkEvent({
    required this.page,
    required this.size,
    required this.isLoadMore,
  });

  @override
  List<Object?> get props => [page, size, isLoadMore];
}

class GetInfoEvent extends ConnectMediaEvent {
  final TypeConnect type;
  final String id;

  const GetInfoEvent({
    required this.type,
    required this.id,
  });

  @override
  List<Object?> get props => [type, id];
}

class UpdateUrlEvent extends ConnectMediaEvent {
  final TypeConnect type;
  final String id;
  final String url;

  const UpdateUrlEvent({
    required this.type,
    required this.id,
    required this.url,
  });

  @override
  List<Object?> get props => [type, id, url];
}

class UpdateSharingEvent extends ConnectMediaEvent {
  final TypeConnect type;
  final List<String> notificationTypes;
  final List<String> notificationContents;
  final String id;

  const UpdateSharingEvent({
    required this.type,
    required this.notificationTypes,
    required this.notificationContents,
    required this.id,
  });

  @override
  List<Object?> get props =>
      [type, id, notificationTypes, notificationContents];
}

class AddBankMediaEvent extends ConnectMediaEvent {
  final TypeConnect type;

  final String? webhookId;
  final List<String>? listBankId;

  const AddBankMediaEvent({
    this.webhookId,
    this.listBankId,
    required this.type,
  });

  @override
  List<Object?> get props => [listBankId, webhookId, type];
}

class RemoveMediaEvent extends ConnectMediaEvent {
  final TypeConnect type;

  final String? webhookId;
  final String? bankId;

  const RemoveMediaEvent({
    this.webhookId,
    this.bankId,
    required this.type,
  });

  @override
  List<Object?> get props => [bankId, webhookId, type];
}

class CheckWebhookUrlEvent extends ConnectMediaEvent {
  final TypeConnect type;

  final String? url;

  const CheckWebhookUrlEvent({
    this.url,
    required this.type,
  });

  @override
  List<Object?> get props => [url, type];
}

class MakeMediaConnectionEvent extends ConnectMediaEvent {
  final TypeConnect type;
  final String? name;
  final List<String>? listBankId;
  final List<String>? notificationTypes;
  final List<String>? notificationContents;

  final String? webhook;

  const MakeMediaConnectionEvent({
    this.name,
    this.listBankId,
    this.notificationTypes,
    this.notificationContents,
    this.webhook,
    required this.type,
  });

  @override
  List<Object?> get props => [
        listBankId,
        webhook,
        notificationTypes,
        notificationContents,
        type,
        name
      ];
}

class DeleteWebhookEvent extends ConnectMediaEvent {
  final TypeConnect type;

  final String? id;

  const DeleteWebhookEvent({
    this.id,
    required this.type,
  });

  @override
  List<Object?> get props => [id, type];
}
