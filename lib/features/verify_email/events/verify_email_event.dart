import 'package:equatable/equatable.dart';

class EmailEvent extends Equatable {
  const EmailEvent();

  @override
  List<Object?> get props => [];
}

class SendOTPEvent extends EmailEvent {
  final Map<String, dynamic> param;
  const SendOTPEvent({required this.param});

  @override
  List<Object?> get props => [param];
}
