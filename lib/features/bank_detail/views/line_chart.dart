import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class StatisticalLineChart extends StatelessWidget {
  const StatisticalLineChart({Key? key}) : super(key: key);
  LineChartData get sampleData1 => LineChartData(
      gridData: griData,
      titlesData: titlesData,
      borderData: borderData,
      lineBarsData: lineBarsData,
      maxX: 12,
      maxY: 4,
      minX: 0,
      minY: 0);

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
    const style = TextStyle(
        fontSize: 15, fontWeight: FontWeight.bold, color: AppColor.GREY_TEXT);
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1m';
        break;
      case 2:
        text = '2m';
        break;
      case 3:
        text = '3m';
        break;
      case 4:
        text = '4m';
        break;
      case 5:
        text = '5m';
        break;
      default:
        return const SizedBox.shrink();
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
    const style = TextStyle(
        fontSize: 15, fontWeight: FontWeight.bold, color: AppColor.GREY_TEXT);
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text(
          '2',
          style: style,
        );
        break;
      case 3:
        text = const Text(
          '3',
          style: style,
        );
        break;
      case 4:
        text = const Text(
          '4',
          style: style,
        );
        break;
      case 5:
        text = const Text(
          '5',
          style: style,
        );
        break;
      case 6:
        text = const Text(
          '6',
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
        bottom: BorderSide(color: AppColor.GREY_TEXT, width: 4),
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
          spots: const [
            FlSpot(1, 5),
            FlSpot(2, 4),
            FlSpot(3, 2),
            FlSpot(4, 2.3),
            FlSpot(5, 1.5),
          ]);
  FlGridData get griData => FlGridData(show: true);
  @override
  Widget build(BuildContext context) {
    return LineChart(
        swapAnimationDuration: const Duration(milliseconds: 250), sampleData1);
  }
}
