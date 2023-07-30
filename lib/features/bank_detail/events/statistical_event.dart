import 'package:equatable/equatable.dart';

class StatisticEvent extends Equatable {
  const StatisticEvent();

  @override
  List<Object?> get props => [];
}

class StatisticEventGetOverview extends StatisticEvent {
  final String bankId;
  const StatisticEventGetOverview({required this.bankId});

  @override
  List<Object?> get props => [bankId];
}

class StatisticEventGetData extends StatisticEvent {
  final String bankId;
  final int type;
  const StatisticEventGetData({required this.bankId, required this.type});

  @override
  List<Object?> get props => [bankId, type];
}
