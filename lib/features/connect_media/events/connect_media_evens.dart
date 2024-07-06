import 'package:equatable/equatable.dart';
import 'package:vierqr/features/connect_media/connect_media_screen.dart';

class ConnectMediaEvent extends Equatable {
  const ConnectMediaEvent();

  @override
  List<Object?> get props => [];
}

class GetInfoEvent extends ConnectMediaEvent {
  final TypeConnect type;

  GetInfoEvent({
    required this.type,
  });

  @override
  List<Object?> get props => [type];
}

class AddBankMediaEvent extends ConnectMediaEvent {
  final TypeConnect type;

  final String? webhookId;
  final List<String>? listBankId;

  AddBankMediaEvent({
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

  RemoveMediaEvent({
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

  final List<String>? listBankId;
  final List<String>? notificationTypes;
  final List<String>? notificationContents;

  final String? webhook;

  const MakeMediaConnectionEvent({
    this.listBankId,
    this.notificationTypes,
    this.notificationContents,
    this.webhook,
    required this.type,
  });

  @override
  List<Object?> get props =>
      [listBankId, webhook, notificationTypes, notificationContents, type];
}

class DeleteWebhookEvent extends ConnectMediaEvent {
  final TypeConnect type;

  final String? id;

  DeleteWebhookEvent({
    this.id,
    required this.type,
  });

  @override
  List<Object?> get props => [id, type];
}
