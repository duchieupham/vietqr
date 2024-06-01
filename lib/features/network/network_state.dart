import 'package:equatable/equatable.dart';

abstract class NetworkState extends Equatable {
  final bool isInternet;

  NetworkState({required this.isInternet});

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
  NetworkNone({required super.isInternet});
}

class NetworkSuccess extends NetworkState {
  NetworkSuccess({required NetworkState state, required super.isInternet})
      : super();
}

class NetworkFailure extends NetworkState {
  NetworkFailure({required NetworkState state, required super.isInternet})
      : super();
}
