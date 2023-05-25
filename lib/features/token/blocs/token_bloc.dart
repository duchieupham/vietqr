import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/logout/repositories/log_out_repository.dart';
import 'package:vierqr/features/token/events/token_event.dart';
import 'package:vierqr/features/token/repositories/token_repository.dart';
import 'package:vierqr/features/token/states/token_state.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  TokenBloc() : super(TokenInitialState()) {
    on<TokenEventCheckValid>(_checkValidToken);
    on<TokenFcmUpdateEvent>(_updateFcmToken);
    on<TokenEventLogout>(_logout);
  }
}

const TokenRepository tokenRepository = TokenRepository();
const LogoutRepository logoutRepository = LogoutRepository();

void _logout(TokenEvent event, Emitter emit) async {
  try {
    if (event is TokenEventLogout) {
      bool check = await logoutRepository.logout();
      if (check) {
        emit(TokenExpiredLogoutState());
      } else {
        emit(TokenLogoutFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(TokenLogoutFailedState());
  }
}

void _checkValidToken(TokenEvent event, Emitter emit) async {
  try {
    if (event is TokenEventCheckValid) {
      emit(TokenCheckingState());
      int check = await tokenRepository.checkValidToken();
      if (check == 0) {
        emit(TokenInvalidState());
      } else if (check == 1) {
        emit(TokenValidState());
      } else if (check == 2) {
        emit(SystemMaintainState());
      } else if (check == 3) {
        emit(SystemConnectionFailedState());
      } else if (check == 4) {
        emit(TokenExpiredState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(TokenInvalidState());
  }
}

void _updateFcmToken(TokenEvent event, Emitter emit) async {
  try {
    if (event is TokenFcmUpdateEvent) {
      bool check = await tokenRepository.updateFcmToken();
      if (check) {
        emit(TokenFcmUpdateSuccessState());
      } else {
        emit(TokenFcmUpdateFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(TokenFcmUpdateFailedState());
  }
}
