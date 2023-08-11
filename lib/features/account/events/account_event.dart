import 'dart:io';

import 'package:equatable/equatable.dart';

class AccountEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingAccountEvent extends AccountEvent {}

class InitAccountEvent extends AccountEvent {}

class LogoutEventSubmit extends AccountEvent {}

class UpdateAvatarEvent extends AccountEvent {
  final String userId;
  final String imgId;
  final File? image;

  UpdateAvatarEvent({
    required this.userId,
    required this.imgId,
    required this.image,
  });

  @override
  List<Object?> get props => [userId, imgId, image];
}

class GetUserInformation extends AccountEvent {}

class UpdateVoiceSetting extends AccountEvent {
  final Map<String, dynamic> param;

  UpdateVoiceSetting({
    required this.param,
  });

  @override
  List<Object?> get props => [param];
}
