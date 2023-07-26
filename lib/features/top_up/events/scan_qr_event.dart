import 'package:equatable/equatable.dart';

class TopUpEvent extends Equatable {
  const TopUpEvent();

  @override
  List<Object?> get props => [];
}

class TopUpEventCreateQR extends TopUpEvent {
  final Map<String, dynamic> data;

  const TopUpEventCreateQR({required this.data});

  @override
  List<Object?> get props => [data];
}
