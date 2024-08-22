import 'package:equatable/equatable.dart';

class PinState extends Equatable {
  final int pinLength;

  const PinState({this.pinLength = 0});

  PinState copyWith({int? pinLength}) {
    return PinState(pinLength: pinLength ?? this.pinLength);
  }

  @override
  List<Object?> get props => [pinLength];
}
