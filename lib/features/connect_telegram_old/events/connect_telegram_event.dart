import 'package:equatable/equatable.dart';

class ConnectTelegramEvent extends Equatable {
  const ConnectTelegramEvent();

  @override
  List<Object?> get props => [];
}

class InsertTelegram extends ConnectTelegramEvent {
  final Map<String, dynamic> data;

  const InsertTelegram({required this.data});

  @override
  List<Object?> get props => [data];
}

class SendFirstMessage extends ConnectTelegramEvent {
  final String chatId;

  const SendFirstMessage({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}

class GetInformationTeleConnect extends ConnectTelegramEvent {
  final String userId;

  const GetInformationTeleConnect({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class RemoveTeleConnect extends ConnectTelegramEvent {
  final String teleConnectId;

  const RemoveTeleConnect({required this.teleConnectId});

  @override
  List<Object?> get props => [teleConnectId];
}

class RemoveBankTelegramEvent extends ConnectTelegramEvent {
  final Map<String, dynamic> body;

  const RemoveBankTelegramEvent(this.body);

  @override
  List<Object?> get props => [body];
}

class AddBankTelegramEvent extends ConnectTelegramEvent {
  final Map<String, dynamic> body;

  const AddBankTelegramEvent(this.body);

  @override
  List<Object?> get props => [body];
}
