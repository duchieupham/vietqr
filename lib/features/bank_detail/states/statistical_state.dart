import 'package:equatable/equatable.dart';
import 'package:vierqr/models/statistical_dto.dart';

class StatisticState extends Equatable {
  const StatisticState();

  @override
  List<Object?> get props => [];
}

class StatisticInitialState extends StatisticState {}

class StatisticLoadingState extends StatisticState {}

class StatisticGetAllDataSuccessState extends StatisticState {
  final ResponseStatisticDTO dto;
  final List<ResponseStatisticDTO> listData;
  const StatisticGetAllDataSuccessState({
    required this.dto,
    required this.listData,
  });

  @override
  List<Object?> get props => [dto, listData];
}

class StatisticGetOverviewFailedState extends StatisticState {
  final ResponseStatisticDTO dto;

  const StatisticGetOverviewFailedState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class StatisticGetDataTableSuccessState extends StatisticState {
  final List<ResponseStatisticDTO> listData;

  const StatisticGetDataTableSuccessState({
    required this.listData,
  });

  @override
  List<Object?> get props => [listData];
}

class StatisticGetDataTableFailedState extends StatisticState {}
