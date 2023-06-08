import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/features/register/events/register_event.dart';
import 'package:vierqr/features/register/repositories/register_repository.dart';
import 'package:vierqr/features/register/states/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/models/response_message_dto.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitialState()) {
    on<RegisterEventSubmit>(_register);
  }

  void _register(RegisterEvent event, Emitter emit) async {
    try {
      if (event is RegisterEventSubmit) {
        emit(RegisterLoadingState());
        ResponseMessageDTO responseMessageDTO =
            await registerRepository.register(event.dto);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(RegisterSuccessState());
        } else {
          String msg =
              ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
          emit(RegisterFailedState(msg: msg));
        }
      }
    } catch (e) {
      print('Error at register - RegisterBloc: $e');
      emit(const RegisterFailedState(
          msg: 'Không thể đăng ký. Vui lòng kiểm tra lại kết nối.'));
    }
  }
}

const RegisterRepository registerRepository = RegisterRepository();
