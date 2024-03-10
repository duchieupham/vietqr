import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vierqr/commons/constants/configurations/numeral.dart';

import 'package:vierqr/models/statistical_dto.dart';

import '../../../commons/constants/configurations/theme.dart';

class LineChartCustom extends StatefulWidget {
  final List<ResponseStatisticDTO> listData;
  final List<List<ResponseStatisticDTO>> listSeparate;
  final int type;

  const LineChartCustom(
      {Key? key,
      required this.listData,
      required this.listSeparate,
      required this.type})
      : super(key: key);

  @override
  State<LineChartCustom> createState() => _LineChartCustomState();
}

class _LineChartCustomState extends State<LineChartCustom> {
  // List<ResponseStatisticDTO> listStatistic = [];

  int getDaysInMonth(int year, int month) {
    DateTime firstDayOfNextMonth = DateTime(year, month + 1, 1);
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(Duration(days: 1));

    return lastDayOfMonth.day;
  }

  @override
  void initState() {
    super.initState();
  }

  int get maxValueAmount {
    if (widget.listData.isEmpty) return 0;
    ResponseStatisticDTO statisticDTOIn = widget.listData.reduce(
        (curr, next) => curr.totalCashIn > next.totalCashIn ? curr : next);
    ResponseStatisticDTO statisticDTOOut = widget.listData.reduce(
        (curr, next) => curr.totalCashOut > next.totalCashOut ? curr : next);
    if (statisticDTOIn.totalCashIn > statisticDTOOut.totalCashOut) {
      return statisticDTOIn.totalCashIn;
    } else {
      return statisticDTOIn.totalCashOut;
    }
  }

  int get conversionRate {
    if (maxValueAmount > Numeral.MILLION) return Numeral.MILLION;
    if (maxValueAmount > Numeral.BILLION) return Numeral.BILLION;
    return 1000;
  }

  String get currencyUnit {
    if (maxValueAmount > Numeral.MILLION) return 'tr';
    if (maxValueAmount > Numeral.BILLION) return 'tỷ';
    return 'k';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Số tiền\n(VND)',
            style: TextStyle(fontSize: 10),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SfCartesianChart(
                          enableAxisAnimation: true,
                          primaryXAxis: CategoryAxis(isInversed: false),
                          primaryYAxis: NumericAxis(
                              labelFormat: '{value}$currencyUnit',
                              labelAlignment: LabelAlignment.center),
                          series: <SplineSeries<ResponseStatisticDTO, String>>[
                            SplineSeries<ResponseStatisticDTO, String>(
                              dataSource: widget.listData,
                              xValueMapper: (ResponseStatisticDTO dto, _) {
                                return dto.getDayFromMonth();
                              },
                              yValueMapper: (ResponseStatisticDTO dto, _) {
                                return (dto.totalCashIn / conversionRate);
                              },
                              color: AppColor.GREEN,
                              markerSettings: MarkerSettings(
                                isVisible: true,
                                height: 3,
                                width: 3,
                                color: AppColor.GREEN,
                              ),
                            ),
                            SplineSeries<ResponseStatisticDTO, String>(
                                dataSource: widget.listData,
                                xValueMapper: (ResponseStatisticDTO dto, _) =>
                                    dto.getDayFromMonth(),
                                color: AppColor.RED_TEXT,
                                markerSettings: MarkerSettings(
                                  isVisible: true,
                                  height: 3,
                                  width: 3,
                                  color: AppColor.RED_TEXT,
                                ),
                                yValueMapper: (ResponseStatisticDTO dto, _) =>
                                    dto.totalCashOut / conversionRate),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 0,
                        child: Text(
                          'Thời gian\n(${widget.type == 0 ? 'Giờ' : 'Ngày'})',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 8),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12)
        ],
      ),
    );
  }
}
