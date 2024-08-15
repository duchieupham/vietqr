import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/features/register/states/pin_state.dart';

class PinCubit extends Cubit<PinState> {
  PinCubit() : super(const PinState());

  void updatePinLength(int length) {
    emit(state.copyWith(pinLength: length));
  }

  void reset() {
    emit(const PinState(pinLength: 0));
  }
}