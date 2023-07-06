import 'package:vierqr/features/login/events/login_event.dart';
import 'package:vierqr/features/login/repositories/login_repository.dart';
import 'package:vierqr/features/login/states/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginEventByPhone>(_login);
  }
}

const LoginRepository loginRepository = LoginRepository();

void _login(LoginEvent event, Emitter emit) async {
  try {
    if (event is LoginEventByPhone) {
      emit(LoginLoadingState());
      bool check = await loginRepository.login(event.dto);
      if (check) {
        emit(LoginSuccessfulState(isToast: event.isToast));
      } else {
        emit(LoginFailedState());
      }
    }
  } catch (e) {
    print('Error at login - LoginBloc: $e');
    emit(LoginFailedState());
  }
}
