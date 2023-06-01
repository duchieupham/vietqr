import 'package:equatable/equatable.dart';

class IntroduceState extends Equatable {
  const IntroduceState();

  @override
  List<Object?> get props => [];
}

class IntroduceInitialState extends IntroduceState {}

class IntroduceLoadingState extends IntroduceState {}

class IntroduceSuccessfulState extends IntroduceState {}

class IntroduceFailedState extends IntroduceState {}
