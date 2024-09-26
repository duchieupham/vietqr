import 'package:flutter_bloc/flutter_bloc.dart';
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
            listStatistics: const [],
            listSeparate: const [],
            statisticDTO: ResponseStatisticDTO())) {
    on<StatisticEventGetOverview>(_getDataOverview);
    on<StatisticEventGetData>(_getDataTerminal);
  }

  void _getDataOverview(StatisticEvent event, Emitter emit) async {
    ResponseStatisticDTO dto = ResponseStatisticDTO();
    try {
      if (event is StatisticEventGetOverview) {
        emit(state.copyWith(request: StatisticType.NONE));
        if (event.type == 0) {
          dto = await _statisticRepository.getDataOverviewByDay(
            bankId: bankId,
            userId: SharePrefUtils.getProfile().userId,
            terminalCode: event.terminalCode,
            toDate: event.toDate,
            fromDate: event.fromDate,
          );
        } else {
          dto = await _statisticRepository.getDataOverview(
            bankId: bankId,
            userId: SharePrefUtils.getProfile().userId,
            terminalCode: event.terminalCode,
            month: event.toDate,
          );
        }
        dto.type = event.type;

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
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(const Duration(days: 1));

    return lastDayOfMonth.day;
  }

  void _getDataTerminal(StatisticEvent event, Emitter emit) async {
    List<ResponseStatisticDTO> list = [];
    try {
      if (event is StatisticEventGetData) {
        emit(state.copyWith(
            request: StatisticType.NONE, status: BlocStatus.LOADING_PAGE));
        //type = 0 : call api theo ngày
        //type = 1 : call api theo tháng
        if (event.type == 1) {
          list = await _statisticRepository.getDataTable(
            bankId: bankId,
            userId: SharePrefUtils.getProfile().userId,
            terminalCode: event.terminalCode,
            month: event.toDate,
          );
          list.sort((a, b) => a.date.compareTo(b.date));
        } else {
          list = await _statisticRepository.getDataTableByDay(
              bankId: bankId,
              userId: SharePrefUtils.getProfile().userId,
              terminalCode: event.terminalCode,
              toDate: event.toDate,
              fromDate: event.fromDate);
          list.sort((a, b) => a.timeDate.compareTo(b.timeDate));
        }

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
