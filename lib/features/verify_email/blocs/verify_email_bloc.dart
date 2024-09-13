import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/features/verify_email/events/verify_email_event.dart';
import 'package:vierqr/features/verify_email/repositories/verify_email_repositories.dart';
import 'package:vierqr/features/verify_email/states/verify_email_state.dart';
import 'package:vierqr/models/key_free_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class EmailBloc extends Bloc<EmailEvent, EmailState> {
  EmailBloc() : super(EmailInitialState()) {
    on<SendOTPEvent>(_sendOTP);
    on<SendOTPAgainEvent>(_sendOTPAgain);
    on<ConfirmOTPEvent>(_confirmOTP);
    on<GetKeyFreeEvent>(_getKeyFree);
    // on<UpdateEmailEvent>(_updateEmail);
  }
}

const EmailRepository emailRepository = EmailRepository();

void _sendOTP(EmailEvent event, Emitter emit) async {
  ResponseMessageDTO dto = const ResponseMessageDTO(status: '', message: '');
  try {
    if (event is SendOTPEvent) {
      emit(SendOTPState());
      dto = await emailRepository.sendOTP(event.param);

      if (dto.status == "SUCCESS") {
        emit(SendOTPSuccessfulState());
      } else {
        emit(SendOTPFailedState(dto: dto));
      }
    }
  } catch (e) {
    emit(SendOTPFailedState(dto: dto));
  }
}

void _sendOTPAgain(EmailEvent event, Emitter emit) async {
  ResponseMessageDTO dto = const ResponseMessageDTO(status: '', message: '');
  try {
    if (event is SendOTPAgainEvent) {
      emit(SendOTPState());
      dto = await emailRepository.sendOTP(event.param);

      if (dto.status == "SUCCESS") {
        emit(SendOTPAgainSuccessfulState());
      } else {
        emit(SendOTPAgainFailedState(dto: dto));
      }
    }
  } catch (e) {
    emit(SendOTPAgainFailedState(dto: dto));
  }
}

void _confirmOTP(EmailEvent event, Emitter emit) async {
  ResponseMessageDTO dto = const ResponseMessageDTO(status: '', message: '');
  try {
    if (event is ConfirmOTPEvent) {
      emit(ConfirmOTPState());
      dto = await emailRepository.confirmOTP(event.param);

      if (dto.status == "SUCCESS") {
        emit(ConfirmOTPStateSuccessfulState());
      } else if (dto.message == 'E175') {
        emit(ConfirmOTPStateFailedTimeOutState(dto: dto));
      } else {
        emit(ConfirmOTPStateFailedState(dto: dto));
      }
    }
  } catch (e) {
    emit(ConfirmOTPStateFailedState(dto: dto));
  }
}

void _getKeyFree(EmailEvent event, Emitter emit) async {
  try {
    if (event is GetKeyFreeEvent) {
      emit(GetKeyFreeState());
      final KeyFreeDTO keyFreeDTO =
          await emailRepository.getKeyFree(event.param);

      if (keyFreeDTO.keyActive.isNotEmpty) {
        emit(GetKeyFreeSuccessfulState(keyFreeDTO: keyFreeDTO, dto: event.dto));
      } else {
        emit(GetKeyFreeFailedState(keyFreeDTO: keyFreeDTO));
      }
    }
  } catch (e) {
    emit(GetKeyFreeFailedState(
        keyFreeDTO: KeyFreeDTO(keyActive: '', bankId: '', status: 0)));
  }
}

// void _updateEmail(EmailEvent event, Emitter emit) async {
//   ResponseMessageDTO dto = const ResponseMessageDTO(status: '', message: '');
//   try {
//     if (event is UpdateEmailEvent) {
//       emit(UpdateEmailState());
//       dto = await emailRepository.updateEmail(
//           email: event.email,
//           otp: event.otp,
//           type: event.type,
//           userId: event.userId);
//       if (event.type == 0) {
//         if (dto.status == "SUCCESS") {
//           emit(SaveEmailSuccessState(message: dto));
//         } else {
//           emit(UpdateEmailFailedState(dto: dto));
//         }
//       } else {
//         if (dto.status == "SUCCESS") {
//           emit(UpdateEmailSuccessState(message: dto));
//         } else {
//           emit(UpdateEmailFailedState(dto: dto));
//         }
//       }
//     }
//   } catch (e) {
//     emit(UpdateEmailFailedState(dto: dto));
//   }
// }
