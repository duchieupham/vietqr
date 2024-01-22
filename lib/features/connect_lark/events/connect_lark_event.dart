import 'package:equatable/equatable.dart';

class ConnectLarkEvent extends Equatable {
  const ConnectLarkEvent();

  @override
  List<Object?> get props => [];
}

class InsertLark extends ConnectLarkEvent {
  final Map<String, dynamic> data;

  const InsertLark({required this.data});

  @override
  List<Object?> get props => [data];
}

class SendFirstMessage extends ConnectLarkEvent {
  final String webhook;

  const SendFirstMessage({required this.webhook});

  @override
  List<Object?> get props => [webhook];
}

class GetInformationLarkConnect extends ConnectLarkEvent {
  final String userId;

  const GetInformationLarkConnect({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class RemoveLarkConnect extends ConnectLarkEvent {
  final String larkConnectId;

  const RemoveLarkConnect({required this.larkConnectId});

  @override
  List<Object?> get props => [larkConnectId];
}

class RemoveBankLarkEvent extends ConnectLarkEvent {
  final Map<String, dynamic> body;

  RemoveBankLarkEvent(this.body);

  @override
  List<Object?> get props => [body];
}

class AddBankLarkEvent extends ConnectLarkEvent {
  final Map<String, dynamic> body;

  AddBankLarkEvent(this.body);

  @override
  List<Object?> get props => [body];
}
