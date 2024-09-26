import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';

abstract class NetworkEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NetworkObserve extends NetworkEvent {}

class NetworkNotify extends NetworkEvent {
  final bool isFirst;
  final bool isInternet;
  final TypeInternet result;

  NetworkNotify({
    this.isFirst = false,
    this.isInternet = false,
    this.result = TypeInternet.NONE,
  });

  @override
  List<Object?> get props => [isFirst, result, isInternet];
}
