import 'package:equatable/equatable.dart';

abstract class NetworkState extends Equatable {
  final bool isInternet;

  const NetworkState({required this.isInternet});

  @override
  List<Object?> get props => [isInternet];
}

class NetworkInitial extends NetworkState {
  NetworkInitial({required NetworkState state})
      : super(
          isInternet: state.isInternet,
        );
}

class NetworkNone extends NetworkState {
  const NetworkNone({required super.isInternet});
}

class NetworkSuccess extends NetworkState {
  const NetworkSuccess({required NetworkState state, required super.isInternet})
      : super();
}

class NetworkFailure extends NetworkState {
  const NetworkFailure({required NetworkState state, required super.isInternet})
      : super();
}
