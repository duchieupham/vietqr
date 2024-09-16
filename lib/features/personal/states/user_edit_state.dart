import 'dart:io';

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

class UserEditAvatarSuccessState extends UserEditState {
  final File? imageFile;

  const UserEditAvatarSuccessState({this.imageFile});

  @override
  List<Object?> get props => [imageFile];
}

class UserEditAvatarFailedState extends UserEditState {
  final String message;

  const UserEditAvatarFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

class UserDeactiveSuccessState extends UserEditState {}

class UserDeactiveFailedState extends UserEditState {
  final String message;

  const UserDeactiveFailedState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}


class UserEditEmailFailedState extends UserEditState {
  final String message;

  const UserEditEmailFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

class UserEditEmailSuccessState extends UserEditState {}