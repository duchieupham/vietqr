import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/features/verify_email/events/verify_email_event.dart';
import 'package:vierqr/features/verify_email/repositories/verify_email_repositories.dart';
import 'package:vierqr/features/verify_email/states/verify_email_state.dart';
import 'package:vierqr/models/response_message_dto.dart';

class EmailBloc extends Bloc<EmailEvent, EmailState> {
  EmailBloc() : super(EmailInitialState()) {
    on<SendOTPEvent>(_sendOTP);
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
