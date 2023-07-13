import 'package:equatable/equatable.dart';

class AccountEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingAccountEvent extends AccountEvent {}

class InitAccountEvent extends AccountEvent {}

class LogoutEventSubmit extends AccountEvent {}
