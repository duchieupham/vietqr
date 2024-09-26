import 'package:equatable/equatable.dart';

class DetailGroupEvent extends Equatable {
  const DetailGroupEvent();

  @override
  List<Object?> get props => [];
}

class GetDetailGroup extends DetailGroupEvent {
  final String id;
  final bool loadingPage;
  const GetDetailGroup({
    required this.id,
    this.loadingPage = true,
  });

  @override
  List<Object?> get props => [id];
}

class RemoveMemberGroup extends DetailGroupEvent {
  final String userId;
  final String terminalId;
  const RemoveMemberGroup({
    required this.userId,
    required this.terminalId,
  });

  @override
  List<Object?> get props => [userId, terminalId];
}

class AddMemberGroup extends DetailGroupEvent {
  final String userId;
  final String terminalId;
  const AddMemberGroup({
    required this.userId,
    required this.terminalId,
  });

  @override
  List<Object?> get props => [userId, terminalId];
}

class AddBankToGroup extends DetailGroupEvent {
  final Map<String, dynamic> param;
  const AddBankToGroup({
    required this.param,
  });

  @override
  List<Object?> get props => [param];
}

class RemoveBankToGroup extends DetailGroupEvent {
  final Map<String, dynamic> param;
  const RemoveBankToGroup({
    required this.param,
  });

  @override
  List<Object?> get props => [param];
}
