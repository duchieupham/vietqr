import 'package:equatable/equatable.dart';

class TokenState extends Equatable {
  const TokenState();

  @override
  List<Object?> get props => [];
}

class TokenInitialState extends TokenState {}

class TokenValidState extends TokenState {}

class TokenInvalidState extends TokenState {}
