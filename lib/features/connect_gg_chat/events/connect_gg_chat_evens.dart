import 'package:equatable/equatable.dart';

class ConnectGgChatEvent extends Equatable {
  const ConnectGgChatEvent();

  @override
  List<Object?> get props => [];
}

class GetInfoEvent extends ConnectGgChatEvent {}

class AddBankGgChatEvent extends ConnectGgChatEvent {
  final String? webhookId;
  final List<String>? listBankId;

  AddBankGgChatEvent({
    this.webhookId,
    this.listBankId,
  });

  @override
  List<Object?> get props => [listBankId, webhookId];
}

class RemoveGgChatEvent extends ConnectGgChatEvent {
  final String? webhookId;
  final String? bankId;

  RemoveGgChatEvent({
    this.webhookId,
    this.bankId,
  });

  @override
  List<Object?> get props => [bankId, webhookId];
}

class CheckWebhookUrlEvent extends ConnectGgChatEvent {
  final String? url;

  CheckWebhookUrlEvent({
    this.url,
  });

  @override
  List<Object?> get props => [url];
}

class MakeGgChatConnectionEvent extends ConnectGgChatEvent {
  final List<String>? listBankId;
  final List<String>? notificationTypes;
  final List<String>? notificationContents;

  final String? webhook;

  const MakeGgChatConnectionEvent({
    this.listBankId,
    this.notificationTypes,
    this.notificationContents,
    this.webhook,
  });

  @override
  List<Object?> get props =>
      [listBankId, webhook, notificationTypes, notificationContents];
}

class DeleteWebhookEvent extends ConnectGgChatEvent {
  final String? id;

  DeleteWebhookEvent({
    this.id,
  });

  @override
  List<Object?> get props => [id];
}
