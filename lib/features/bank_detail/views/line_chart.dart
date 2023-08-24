import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vierqr/commons/constants/configurations/numeral.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vierqr/models/statistical_dto.dart';

import '../../../commons/constants/configurations/theme.dart';

class LineChart extends StatefulWidget {
  final List<ResponseStatisticDTO> listData;
  const LineChart({Key? key, required this.listData}) : super(key: key);

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  int conversionRate = 1000;
  String currencyUnit = 'k';
  List<ResponseStatisticDTO> listStatistic = [];
  @override
  void initState() {
    listStatistic = widget.listData;
    // filterList();

    if (maxValueAmount > Numeral.MILLION) {
      currencyUnit = 'tr';
      conversionRate = Numeral.MILLION;
    }
    if (maxValueAmount > Numeral.BILLION) {
      currencyUnit = 'tỷ';
      conversionRate = Numeral.BILLION;
    }
    super.initState();
  }

  Future filterList() async {
    List<int> monthsAvailable = [];
    listStatistic.forEach((element) {
      monthsAvailable.add(int.parse(element.month.substring(5)));
    });
    for (int i = 1; i <= 12; i++) {
      if (!monthsAvailable.contains(i)) {
        String _month = i < 10 ? '0$i' : '$i';
        listStatistic
            .add(ResponseStatisticDTO(month: '${DateTime.now().year}-$_month'));
      }
    }
    await Future.delayed(const Duration(seconds: 1), () {
      listStatistic.sort((a, b) => a.month.compareTo(b.month));
    });
    return listStatistic;
  }

  int get maxValueAmount {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      padding: EdgeInsets.only(top: 12, left: 8, right: 12),
      decoration: BoxDecoration(
          color: AppColor.WHITE, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '(Số tiền)',
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
                          primaryXAxis: CategoryAxis(isInversed: true),
                          primaryYAxis: NumericAxis(
                              labelFormat: '{value}$currencyUnit',
                              labelAlignment: LabelAlignment.center),
                          series: <SplineSeries<ResponseStatisticDTO, String>>[
                            SplineSeries<ResponseStatisticDTO, String>(
                              dataSource: widget.listData,
                              xValueMapper: (ResponseStatisticDTO dto, _) {
                                return dto.getMonth();
                              },
                              color: AppColor.BLUE_TEXT,
                              yValueMapper: (ResponseStatisticDTO dto, _) =>
                                  dto.totalCashIn / conversionRate,
                            ),
                            SplineSeries<ResponseStatisticDTO, String>(
                                dataSource: widget.listData,
                                xValueMapper: (ResponseStatisticDTO dto, _) =>
                                    dto.getMonth(),
                                color: AppColor.RED_TEXT,
                                yValueMapper: (ResponseStatisticDTO dto, _) =>
                                    dto.totalCashOut / conversionRate)
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: 8,
                          right: 0,
                          child: Text(
                            'Thời gian\n(Tháng)',
                            style: TextStyle(fontSize: 8),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              Container(
                height: 10,
                width: 20,
                color: AppColor.BLUE_TEXT,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Nhận tiền đến',
                style: TextStyle(fontSize: 11),
              ),
              const SizedBox(
                width: 24,
              ),
              Container(
                height: 10,
                width: 20,
                color: AppColor.RED_TEXT,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Chuyển tiền đi',
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }
}
