import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_detail/events/statistical_event.dart';
import 'package:vierqr/features/bank_detail/repositories/statistical_repository.dart';
import 'package:vierqr/features/bank_detail/states/statistical_state.dart';
import 'package:vierqr/models/statistical_dto.dart';
import 'package:vierqr/models/terminal_response_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  final TerminalDto? terminalDto;
  final String bankId;

  StatisticBloc(this.terminalDto, this.bankId)
      : super(StatisticState(
            listStatistics: [],
            listSeparate: [],
            statisticDTO: ResponseStatisticDTO())) {
    on<StatisticEventGetOverview>(_getDataOverview);
    on<StatisticEventGetData>(_getDataTerminal);
  }

  void _getDataOverview(StatisticEvent event, Emitter emit) async {
    ResponseStatisticDTO dto = ResponseStatisticDTO();
    try {
      if (event is StatisticEventGetOverview) {
        emit(state.copyWith(request: StatisticType.NONE));
        dto = await _statisticRepository.getDataOverview(
          bankId: bankId,
          userId: SharePrefUtils.getProfile().userId,
          terminalCode: event.terminalCode,
          month: event.month,
        );
        emit(state.copyWith(
            statisticDTO: dto, request: StatisticType.GET_SINGLE_DTO));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(request: StatisticType.NONE));
    }
  }

  int getDaysInMonth(int year, int month) {
    DateTime firstDayOfNextMonth = DateTime(year, month + 1, 1);
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(Duration(days: 1));

    return lastDayOfMonth.day;
  }

  void _getDataTerminal(StatisticEvent event, Emitter emit) async {
    List<ResponseStatisticDTO> list = [];
    try {
      if (event is StatisticEventGetData) {
        emit(state.copyWith(
            request: StatisticType.NONE, status: BlocStatus.LOADING_PAGE));
        list = await _statisticRepository.getDataTable(
          bankId: bankId,
          userId: SharePrefUtils.getProfile().userId,
          terminalCode: event.terminalCode,
          month: event.month,
        );

        list.sort((a, b) => a.date.compareTo(b.date));

        emit(state.copyWith(
            listStatistics: list,
            request: StatisticType.GET_LIST,
            status: BlocStatus.NONE,
            listSeparate: []));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        request: StatisticType.NONE,
        status: BlocStatus.NONE,
      ));
    }
  }
}

const StatisticRepository _statisticRepository = StatisticRepository();
