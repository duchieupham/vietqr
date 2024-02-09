import 'package:equatable/equatable.dart';

class StatisticEvent extends Equatable {
  const StatisticEvent();

  @override
  List<Object?> get props => [];
}

class StatisticEventGetOverview extends StatisticEvent {
  final String terminalCode;
  final String month;

  const StatisticEventGetOverview({
    required this.terminalCode,
    required this.month,
  });

  @override
  List<Object?> get props => [
        terminalCode,
        month,
      ];
}

class StatisticEventGetData extends StatisticEvent {
  final String terminalCode;
  final String month;

  const StatisticEventGetData({
    required this.terminalCode,
    required this.month,
  });

  @override
  List<Object?> get props => [terminalCode, month];
}
