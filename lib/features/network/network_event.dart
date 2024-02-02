import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

abstract class NetworkEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NetworkObserve extends NetworkEvent {}

class NetworkNotify extends NetworkEvent {
  final bool isFirst;
  final ConnectivityResult result;

  NetworkNotify({
    this.isFirst = false,
    this.result = ConnectivityResult.none,
  });

  @override
  List<Object?> get props => [isFirst, result];
}
