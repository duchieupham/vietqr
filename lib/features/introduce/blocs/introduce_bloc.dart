import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/features/introduce/events/introduce_event.dart';
import 'package:vierqr/features/introduce/states/introduce_state.dart';

class IntroduceBloc extends Bloc<IntroduceEvent, IntroduceState> {
  IntroduceBloc() : super(IntroduceInitialState()) {
    on<IntroduceEventInit>(_init);
  }
}

void _init(IntroduceEvent event, Emitter emit) {}
