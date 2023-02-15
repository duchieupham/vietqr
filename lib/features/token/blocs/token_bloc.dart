import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/token/events/token_event.dart';
import 'package:vierqr/features/token/repositories/token_repository.dart';
import 'package:vierqr/features/token/states/token_state.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  TokenBloc() : super(TokenInitialState()) {
    on<TokenEventCheckValid>(_checkValidToken);
  }
}

const TokenRepository tokenRepository = TokenRepository();

void _checkValidToken(TokenEvent event, Emitter emit) async {
  try {
    if (event is TokenEventCheckValid) {
      bool check = await tokenRepository.checkValidToken();
      if (check) {
        emit(TokenValidState());
      } else {
        emit(TokenInvalidState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(TokenInvalidState());
  }
}
