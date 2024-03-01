import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/statistical_type.dart';
import 'package:vierqr/models/statistical_dto.dart';
import 'package:vierqr/models/terminal_response_dto.dart';

enum SelectType { DAY, MONTH }

class StatisticProvider extends ChangeNotifier {
  final bool isOwner;

  StatisticProvider(this.isOwner);

  ResponseStatisticDTO _responseStatisticDTO = ResponseStatisticDTO();

  ResponseStatisticDTO get responseStatisticDTO => _responseStatisticDTO;
  TypeStatistical _typeStatistical = TypeStatistical.all;

  TypeStatistical get typeStatistical => _typeStatistical;

  List<TerminalResponseDTO> terminals = [];

  List<StatisticStatusData> listStatisticStatus = [];

  TerminalResponseDTO terminalResponseDTO = TerminalResponseDTO(banks: []);
  StatisticStatusData statisticStatusData =
      StatisticStatusData(type: 0, name: 'Ngày');

  String keySearch = '';
  String codeSearch = '';

  DateTime dateFilter = DateTime.now();

  DateTime timeDay = DateTime.now();

  bool get typeTimeDay => statisticStatusData.type == 0;

  String get getDateTime {
    int month = dateFilter.month;
    int year = dateFilter.year;
    return 'Tháng $month, năm $year';
  }

  String get getDateParent {
    int month = dateFilter.month;
    int year = dateFilter.year;
    return 'Tháng $month/$year';
  }

  String get getTimeDay {
    return 'Ngày ${timeDay.day} tháng ${timeDay.month}, năm ${timeDay.year}';
  }

  String get getParentTimeDay {
    return 'Ngày ${timeDay.day}/${timeDay.month}/${timeDay.year}';
  }

  initData(ResponseStatisticDTO dto) {
    _responseStatisticDTO = dto;
  }

  updateData({
    required List<TerminalResponseDTO> listTerminal,
    required List<StatisticStatusData> listStatusData,
    required DateTime dateTimeFilter,
    required DateTime timeDayParent,
    required TerminalResponseDTO terminal,
    StatisticStatusData? statusData,
    bool isFirst = false,
    required String keySearchParent,
    required String codeSearchParent,
  }) {
    if (isFirst) {
      terminals = [
        TerminalResponseDTO(banks: [], code: 'Tất cả', name: 'Tất cả'),
        ...listTerminal,
      ];
      terminalResponseDTO = terminals.first;
      keySearch = terminalResponseDTO.name;
      codeSearch = terminalResponseDTO.code;
    } else {
      terminals = [...listTerminal];
      terminalResponseDTO = terminal;
      keySearch = keySearchParent;
      codeSearch = codeSearchParent;
    }

    if (listStatusData.isNotEmpty) {
      listStatisticStatus = [...listStatusData];
    }

    if (statusData == null) {
      statisticStatusData = listStatusData.first;
    } else {
      statisticStatusData = statusData;
    }

    dateFilter = dateTimeFilter;
    timeDay = timeDayParent;
    notifyListeners();
  }

  void updateStatisticDTO(ResponseStatisticDTO dto) {
    _responseStatisticDTO = dto;
    notifyListeners();
  }

  void updateTypeStatistical(TypeStatistical type) {
    _typeStatistical = type;
    notifyListeners();
  }

  void updateKeyword(String value) {
    keySearch = value.trim();
    codeSearch = value.trim();
    if (isOwner) terminalResponseDTO = terminals.first;
    notifyListeners();
  }

  void updateCodeSearch(String value) {
    codeSearch = value.trim();
    if (isOwner) terminalResponseDTO = terminals.first;
    notifyListeners();
  }

  void updateStatusData(value) {
    statisticStatusData = value;
    timeDay = DateTime.now();
    dateFilter = DateTime.now();
    notifyListeners();
  }

  void updateTerminalResponseDTO(TerminalResponseDTO? value,
      {bool isUpdate = false}) {
    if (value == null) return;
    terminalResponseDTO = value;
    if (isOwner && !isUpdate) {
      keySearch = value.name;
      codeSearch = value.code;
    }
    notifyListeners();
  }

  updateDateFilter(DateTime date) {
    dateFilter = date;
    notifyListeners();
  }

  onReset() {
    terminalResponseDTO = terminals.first;
    codeSearch = terminalResponseDTO.code;
    keySearch = terminalResponseDTO.name;
    dateFilter = DateTime.now();
    timeDay = DateTime.now();
    notifyListeners();
  }

  void updateTimeDay(DateTime? date) {
    if (date == null) return;
    timeDay = date;
    notifyListeners();
  }
}

class StatisticStatusData {
  final int type;
  final String name;

  StatisticStatusData({required this.type, required this.name});
}
