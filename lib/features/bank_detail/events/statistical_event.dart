import 'package:equatable/equatable.dart';

class StatisticEvent extends Equatable {
  const StatisticEvent();

  @override
  List<Object?> get props => [];
}

class StatisticEventGetOverview extends StatisticEvent {
  final String terminalCode;
  final String toDate;
  final String fromDate;
  final int type;

  const StatisticEventGetOverview({
    required this.terminalCode,
    required this.toDate,
    required this.fromDate,
    required this.type,
  });

  @override
  List<Object?> get props => [terminalCode, toDate, fromDate, type];
}

class StatisticEventGetData extends StatisticEvent {
  final String terminalCode;
  final String fromDate;
  final String toDate;
  final int type;

  const StatisticEventGetData({
    required this.terminalCode,
    required this.fromDate,
    required this.toDate,
    required this.type,
  });

  @override
  List<Object?> get props => [terminalCode, toDate, fromDate, type];
}
