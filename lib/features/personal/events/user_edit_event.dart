import 'package:equatable/equatable.dart';
import 'package:vierqr/models/account_information_dto.dart';

class UserEditEvent extends Equatable {
  const UserEditEvent();
  @override
  List<Object?> get props => [];
}

class UserEditInformationEvent extends UserEditEvent {
  final AccountInformationDTO dto;

  const UserEditInformationEvent({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class UserEditPasswordEvent extends UserEditEvent {
  final String userId;
  final String phoneNo;
  final String oldPassword;
  final String newPassword;

  const UserEditPasswordEvent({
    required this.userId,
    required this.phoneNo,
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [userId, phoneNo, oldPassword, newPassword];
}
