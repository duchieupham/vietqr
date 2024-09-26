// import 'package:equatable/equatable.dart';
// import 'package:vierqr/features/log_sms/blocs/sms_bloc.dart';
// import 'package:vierqr/models/message_dto.dart';

// class SMSEvent extends Equatable {
//   const SMSEvent();

//   @override
//   List<Object?> get props => [];
// }

// class SMSEventGetList extends SMSEvent {
//   const SMSEventGetList();

//   @override
//   List<Object?> get props => [];
// }

// class SMSEventListen extends SMSEvent {
//   final String userId;
//   final SMSBloc smsBloc;

//   const SMSEventListen({required this.userId, required this.smsBloc});

//   @override
//   List<Object?> get props => [userId, smsBloc];
// }

// class SMSEventReceived extends SMSEvent {
//   final String userId;
//   final MessageDTO messageDTO;

//   const SMSEventReceived({required this.userId, required this.messageDTO});

//   @override
//   List<Object?> get props => [userId, messageDTO];
// }
