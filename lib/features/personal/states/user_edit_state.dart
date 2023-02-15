import 'package:equatable/equatable.dart';

class UserEditState extends Equatable {
  const UserEditState();

  @override
  List<Object?> get props => [];
}

class UserEditInitialState extends UserEditState {}

class UserEditLoadingState extends UserEditState {}

class UserEditSuccessfulState extends UserEditState {}

class UserEditFailedState extends UserEditState {
  final String msg;

  const UserEditFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class UserEditPasswordSuccessfulState extends UserEditState {}

class UserEditPasswordFailedState extends UserEditState {
  final String msg;

  const UserEditPasswordFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}
