import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_detail/events/statistical_event.dart';
import 'package:vierqr/features/bank_detail/repositories/statistical_repository.dart';
import 'package:vierqr/features/bank_detail/states/statistical_state.dart';
import 'package:vierqr/models/statistical_dto.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  StatisticBloc() : super(StatisticInitialState()) {
    on<StatisticEventGetOverview>(_getDataOverview);
  }
}

const StatisticRepository _statisticRepository = StatisticRepository();

void _getDataOverview(StatisticEvent event, Emitter emit) async {
  ResponseStatisticDTO dto = const ResponseStatisticDTO();
  List<ResponseStatisticDTO> list = [];
  try {
    if (event is StatisticEventGetOverview) {
      dto = await _statisticRepository.getDataOverview(event.bankId);
      list = await _statisticRepository.getDataTable(
          bankId: event.bankId, type: 2);
      emit(StatisticGetAllDataSuccessState(dto: dto, listData: list));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(StatisticGetOverviewFailedState(dto: dto));
  }
}
