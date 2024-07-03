import 'package:equatable/equatable.dart';

class QrFeedEvent extends Equatable {
  const QrFeedEvent();

  @override
  List<Object?> get props => [];
}

class GetQrFeedEvent extends QrFeedEvent {
  final int type;

  const GetQrFeedEvent({required this.type});

  @override
  List<Object?> get props => [type];
}
