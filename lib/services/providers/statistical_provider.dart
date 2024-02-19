import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/statistical_type.dart';
import 'package:vierqr/models/statistical_dto.dart';
import 'package:vierqr/models/terminal_response_dto.dart';

class StatisticProvider extends ChangeNotifier {
  final bool isOwner;

  StatisticProvider(this.isOwner);

  ResponseStatisticDTO _responseStatisticDTO = ResponseStatisticDTO();

  ResponseStatisticDTO get responseStatisticDTO => _responseStatisticDTO;
  TypeStatistical _typeStatistical = TypeStatistical.all;

  TypeStatistical get typeStatistical => _typeStatistical;

  List<TerminalResponseDTO> terminals = [];

  TerminalResponseDTO terminalResponseDTO = TerminalResponseDTO(banks: []);

  String keySearch = '';
  String codeSearch = '';

  DateTime dateFilter = DateTime.now();

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

  initData(ResponseStatisticDTO dto) {
    _responseStatisticDTO = dto;
  }

  updateData({
    required List<TerminalResponseDTO> listTerminal,
    required DateTime dateTimeFilter,
    required TerminalResponseDTO terminal,
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

    dateFilter = dateTimeFilter;
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
    notifyListeners();
  }
}
