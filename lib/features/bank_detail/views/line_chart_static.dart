import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vierqr/commons/constants/configurations/numeral.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/models/statistical_dto.dart';

class StatisticalLineChart extends StatelessWidget {
  final List<ResponseStatisticDTO> listData;

  const StatisticalLineChart({Key? key, required this.listData})
      : super(key: key);

  LineChartData get sampleData1 => LineChartData(
      gridData: griData,
      titlesData: titlesData,
      borderData: borderData,
      lineBarsData: lineBarsData,
      maxX: 12,
      maxY: maxExchangeValueAmount,
      minX: 0,
      minY: 0);

  double get maxExchangeValueAmount {
    ResponseStatisticDTO statisticDTOIn = listData.reduce(
        (curr, next) => curr.totalCashIn > next.totalCashIn ? curr : next);
    ResponseStatisticDTO statisticDTOOut = listData.reduce(
        (curr, next) => curr.totalCashOut > next.totalCashOut ? curr : next);
    if (statisticDTOIn.totalCashIn > statisticDTOOut.totalCashOut) {
      return convertAmount(statisticDTOIn.totalCashIn);
    } else {
      return convertAmount(statisticDTOIn.totalCashIn);
    }
  }

  int get maxValueAmount {
    ResponseStatisticDTO statisticDTOIn = listData.reduce(
        (curr, next) => curr.totalCashIn > next.totalCashIn ? curr : next);
    ResponseStatisticDTO statisticDTOOut = listData.reduce(
        (curr, next) => curr.totalCashOut > next.totalCashOut ? curr : next);
    if (statisticDTOIn.totalCashIn > statisticDTOOut.totalCashOut) {
      return statisticDTOIn.totalCashIn;
    } else {
      return statisticDTOIn.totalCashIn;
    }
  }

  double convertAmount(int amount) {
    return (amount / getExchangeRate(maxValueAmount)).toDouble();
  }

  int amountTable(int value) {
    return value * getExchangeRate(maxValueAmount);
  }

  int getExchangeRate(int maxAmount) {
    if (maxAmount > Numeral.TENS_OF_THOUSANDS &&
        maxAmount < Numeral.HUNDRED_THOUSANDS) {
      return Numeral.TENS_OF_THOUSANDS;
    } else if (maxAmount > Numeral.HUNDRED_THOUSANDS &&
        maxAmount < Numeral.MILLION) {
      return Numeral.HUNDRED_THOUSANDS;
    } else if (maxAmount > Numeral.MILLION &&
        maxAmount < Numeral.TENS_OF_MILLION) {
      return Numeral.MILLION;
    } else if (maxAmount > Numeral.TENS_OF_MILLION &&
        maxAmount < Numeral.HUNDRED_MILLION) {
      return Numeral.TENS_OF_MILLION;
    } else if (maxAmount > Numeral.HUNDRED_MILLION &&
        maxAmount < Numeral.BILLION) {
      return Numeral.HUNDRED_MILLION;
    } else if (maxAmount > Numeral.BILLION &&
        maxAmount < Numeral.TENS_OF_BILLION) {
      return Numeral.BILLION;
    } else if (maxAmount > Numeral.TENS_OF_BILLION &&
        maxAmount < Numeral.HUNDRED_BILLION) {
      return Numeral.TENS_OF_BILLION;
    }
    return Numeral.HUNDRED_BILLION;
  }

  List<LineChartBarData> get lineBarsData => [
        lineCharBarData1,
      ];

  FlTitlesData get titlesData => FlTitlesData(
      bottomTitles: AxisTitles(sideTitles: getBottomTitles),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: AxisTitles(sideTitles: leftTitles));

  Widget _leftTitles(double value, TitleMeta titleMeta) {
    const style = TextStyle(fontSize: 12, color: AppColor.GREY_TEXT);
    String text = '';
    int maxAmount = maxExchangeValueAmount.ceil();
    if (value.toInt() == maxAmount ~/ 5) {
      text = StringUtils.formatNumber(amountTable(maxAmount ~/ 5));
    } else if (value.toInt() == (maxAmount ~/ 5) * 2) {
      text = StringUtils.formatNumber(amountTable((maxAmount ~/ 5) * 2));
    } else if (value == (maxAmount ~/ 5) * 3) {
      text = StringUtils.formatNumber(amountTable((maxAmount ~/ 5) * 3));
    } else if (value == (maxAmount ~/ 5) * 4) {
      text = StringUtils.formatNumber(amountTable((maxAmount ~/ 5) * 4));
    } else if (value == maxValueAmount) {
      text = StringUtils.formatNumber(amountTable(maxAmount));
    }

    return Text(
      text,
      style: style,
      textAlign: TextAlign.center,
    );
  }

  SideTitles get leftTitles => SideTitles(
        getTitlesWidget: _leftTitles,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget _bottomTitleWidget(double value, TitleMeta titleMeta) {
    const style = TextStyle(fontSize: 12, color: AppColor.GREY_TEXT);
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text(
          '1',
          style: style,
        );
        break;
      case 1:
        text = const Text(
          '2',
          style: style,
        );
        break;
      case 2:
        text = const Text(
          '3',
          style: style,
        );
        break;
      case 3:
        text = const Text(
          '4',
          style: style,
        );
        break;
      case 4:
        text = const Text(
          '5',
          style: style,
        );
        break;
      case 5:
        text = const Text(
          '6',
          style: style,
        );
        break;

      case 6:
        text = const Text(
          '7',
          style: style,
        );
        break;
      case 7:
        text = const Text(
          '8',
          style: style,
        );
        break;
      case 8:
        text = const Text(
          '9',
          style: style,
        );
        break;
      case 9:
        text = const Text(
          '10',
          style: style,
        );
        break;
      case 10:
        text = const Text(
          '11',
          style: style,
        );
        break;
      case 11:
        text = const Text(
          '12',
          style: style,
        );
        break;

      default:
        text = const Text('');
    }
    return SideTitleWidget(
      axisSide: titleMeta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get getBottomTitles => SideTitles(
      showTitles: true,
      reservedSize: 32,
      interval: 1,
      getTitlesWidget: _bottomTitleWidget);

  FlBorderData get borderData => FlBorderData(
      show: true,
      border: const Border(
        bottom: BorderSide(color: AppColor.GREY_TEXT, width: 2),
        left: BorderSide(color: AppColor.GREY_TEXT),
        right: BorderSide(color: Colors.transparent),
        top: BorderSide(color: Colors.transparent),
      ));

  LineChartBarData get lineCharBarData1 => LineChartBarData(
      isCurved: true,
      color: AppColor.GREEN,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: getListFlSpot1());

  List<FlSpot> getListFlSpot1() {
    List<FlSpot> flSpots = [];
    for (var element in listData) {
      int index = listData.indexOf(element);
      flSpots.add(
        FlSpot(
            getMonth(element.date), convertAmount(listData[index].totalCashIn)),
      );
    }
    return flSpots;
  }

  double getMonth(String time) {
    DateTime tempDate = DateFormat("yyyy-MM").parse(time);
    int month = tempDate.month - 1;
    return month.toDouble();
  }

  FlGridData get griData => FlGridData(show: true);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      duration: const Duration(milliseconds: 250),
      sampleData1,
    );
  }
}
