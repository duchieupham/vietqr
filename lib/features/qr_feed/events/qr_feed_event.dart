import 'package:equatable/equatable.dart';

class QrFeedEvent extends Equatable {
  const QrFeedEvent();

  @override
  List<Object?> get props => [];
}

class GetQrFeedEvent extends QrFeedEvent {
  final int type;
  final bool isLoading;

  const GetQrFeedEvent({required this.type, required this.isLoading});

  @override
  List<Object?> get props => [type, isLoading];
}

class GetMoreQrFeedEvent extends QrFeedEvent {
  final int type;

  const GetMoreQrFeedEvent({required this.type});

  @override
  List<Object?> get props => [type];
}
