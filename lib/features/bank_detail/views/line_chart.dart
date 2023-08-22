import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vierqr/models/statistical_dto.dart';

class LineChart extends StatefulWidget {
  final List<ResponseStatisticDTO> listData;
  const LineChart({Key? key, required this.listData}) : super(key: key);

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 360,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: LogarithmicAxis(labelFormat: '{value}tr'),
        series: <SplineSeries<ResponseStatisticDTO, String>>[
          SplineSeries<ResponseStatisticDTO, String>(
              dataSource: widget.listData,
              xValueMapper: (ResponseStatisticDTO dto, _) => dto.month,
              yValueMapper: (ResponseStatisticDTO dto, _) =>
                  dto.totalCashIn / 1000000,
              yAxisName: 'name',
              xAxisName: 'name'),
          SplineSeries<ResponseStatisticDTO, String>(
              dataSource: widget.listData,
              xValueMapper: (ResponseStatisticDTO dto, _) => dto.month,
              yValueMapper: (ResponseStatisticDTO dto, _) =>
                  dto.totalCashOut / 1000000)
        ],
      ),
    );
  }
}
