import 'package:equatable/equatable.dart';

class InviteBDSDEvent extends Equatable {
  const InviteBDSDEvent();

  @override
  List<Object?> get props => [];
}

class GetRanDomCode extends InviteBDSDEvent {
  final bool isLoading;

  GetRanDomCode({this.isLoading = false});

  @override
  List<Object?> get props => [isLoading];
}

class CreateNewGroup extends InviteBDSDEvent {
  final Map<String, dynamic> param;

  const CreateNewGroup({
    required this.param,
  });

  @override
  List<Object?> get props => [param];
}

class UpdateGroup extends InviteBDSDEvent {
  final Map<String, dynamic> param;

  const UpdateGroup({
    required this.param,
  });

  @override
  List<Object?> get props => [param];
}

class RemoveGroup extends InviteBDSDEvent {
  final Map<String, dynamic> param;

  const RemoveGroup({
    required this.param,
  });

  @override
  List<Object?> get props => [param];
}
