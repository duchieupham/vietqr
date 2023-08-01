import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/statistical_type.dart';
import 'package:vierqr/models/statistical_dto.dart';

class StatisticProvider extends ChangeNotifier {
  ResponseStatisticDTO _responseStatisticDTO = const ResponseStatisticDTO();

  ResponseStatisticDTO get responseStatisticDTO => _responseStatisticDTO;
  TypeStatistical _typeStatistical = TypeStatistical.all;
  TypeStatistical get typeStatistical => _typeStatistical;
  initData(ResponseStatisticDTO dto) {
    _responseStatisticDTO = dto;
  }

  void updateStatisticDTO(ResponseStatisticDTO dto) {
    _responseStatisticDTO = dto;
    notifyListeners();
  }

  void updateTypeStatistical(TypeStatistical type) {
    _typeStatistical = type;
    notifyListeners();
  }
}
