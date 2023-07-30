import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/features/bank_detail/blocs/statistical_bloc.dart';
import 'package:vierqr/features/bank_detail/events/statistical_event.dart';
import 'package:vierqr/features/bank_detail/states/statistical_state.dart';
import 'package:vierqr/features/bank_detail/views/line_chart.dart';
import 'package:vierqr/models/statistical_dto.dart';

class Statistical extends StatelessWidget {
  final String bankId;
  Statistical({Key? key, required this.bankId}) : super(key: key);
  ResponseStatisticDTO dto = const ResponseStatisticDTO();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticBloc>(
      create: (context) =>
          StatisticBloc()..add(StatisticEventGetOverview(bankId: bankId)),
      child: BlocConsumer<StatisticBloc, StatisticState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is StatisticGetAllDataSuccessState) {
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Container(
                  //   padding: const EdgeInsets.symmetric(vertical: 12),
                  //   width: MediaQuery.of(context).size.width,
                  //   height: 600,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(16),
                  //       color: AppColor.WHITE),
                  //   child: const StatisticalLineChart(),
                  // ),
                  const SizedBox(
                    height: 12,
                  ),
                  _buildOverView(state.dto)
                ],
              );
            }
            return ListView(
              padding: EdgeInsets.zero,
              children: [_buildOverView(dto)],
            );
          }),
    );
  }

  Widget _buildOverView(ResponseStatisticDTO dto) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tổng quan giao dịch',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const Text(
          'Dữ liệu thống kê được ghi nhận bắt đầu từ thời điểm tài khoản ngân hàng của bạn kết nối với hệ thống VietQR VN',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: AppColor.WHITE),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildItemOverView(dto.totalTrans.toString(), title: 'Tổng quan'),
              _buildItemOverView(dto.totalTransC.toString(),
                  title: 'Nhận tiền đến'),
              _buildItemOverView(dto.totalTransD.toString(),
                  title: 'Chuyển tiền đi')
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        _buildTotal(dto)
      ],
    );
  }

  Widget _buildItemOverView(String value, {required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title),
        const SizedBox(
          height: 4,
        ),
        Text(
          value,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColor.BLUE_TEXT),
        ),
        const SizedBox(
          height: 4,
        ),
        const Text(
          'giao dịch',
          style: TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildTotal(ResponseStatisticDTO dto) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: AppColor.WHITE),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Đến'),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      StringUtils.formatNumber(dto.totalCashIn),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColor.GREEN),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Text(
                      'VND',
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 60,
            child: VerticalDivider(
              color: Colors.black,
              thickness: 0.2,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Đi'),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      StringUtils.formatNumber(dto.totalCashOut),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColor.RED_TEXT),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Text(
                      'VND',
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
