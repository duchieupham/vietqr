import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/statistical_dto.dart';

enum StatisticType {
  NONE,
  GET_LIST,
  GET_SINGLE_DTO,
}

class StatisticState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final StatisticType request;
  final List<ResponseStatisticDTO> listStatistics;
  final List<List<ResponseStatisticDTO>> listSeparate;
  final ResponseStatisticDTO statisticDTO;

  const StatisticState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = StatisticType.NONE,
    required this.listStatistics,
    required this.statisticDTO,
    required this.listSeparate,
  });

  StatisticState copyWith({
    BlocStatus? status,
    String? msg,
    StatisticType? request,
    List<ResponseStatisticDTO>? listStatistics,
    List<List<ResponseStatisticDTO>>? listSeparate,
    ResponseStatisticDTO? statisticDTO,
  }) {
    return StatisticState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      statisticDTO: statisticDTO ?? this.statisticDTO,
      listStatistics: listStatistics ?? this.listStatistics,
      listSeparate: listSeparate ?? this.listSeparate,
    );
  }

  @override
  List<Object?> get props => [
        status,
        request,
        msg,
        statisticDTO,
        listStatistics,
        listSeparate,
      ];
}
