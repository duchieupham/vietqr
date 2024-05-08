import 'package:equatable/equatable.dart';

class ConnectGgChatEvent extends Equatable {
  const ConnectGgChatEvent();

  @override
  List<Object?> get props => [];
}

class GetInfoEvent extends ConnectGgChatEvent {}

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
  final String? webhook;

  MakeGgChatConnectionEvent({
    this.listBankId,
    this.webhook,
  });

  @override
  List<Object?> get props => [listBankId, webhook];
}

class DeleteWebhookEvent extends ConnectGgChatEvent {
  final String? id;

  DeleteWebhookEvent({
    this.id,
  });

  @override
  List<Object?> get props => [id];
}
