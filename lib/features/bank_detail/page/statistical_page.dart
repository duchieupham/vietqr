import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/statistical_type.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/features/bank_detail/blocs/statistical_bloc.dart';
import 'package:vierqr/features/bank_detail/events/statistical_event.dart';
import 'package:vierqr/features/bank_detail/states/statistical_state.dart';
import 'package:vierqr/models/statistical_dto.dart';
import 'package:vierqr/services/providers/statistical_provider.dart';

import '../views/line_chart.dart';
import '../views/line_chart_static.dart';

// ignore: must_be_immutable
class Statistical extends StatelessWidget {
  final String bankId;

  Statistical({Key? key, required this.bankId}) : super(key: key);
  ResponseStatisticDTO dto = const ResponseStatisticDTO();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ChangeNotifierProvider(
        create: (context) => StatisticProvider(),
        child: BlocProvider<StatisticBloc>(
          create: (context) =>
              StatisticBloc()..add(StatisticEventGetOverview(bankId: bankId)),
          child: BlocConsumer<StatisticBloc, StatisticState>(
              listener: (context, state) {
            if (state is StatisticGetAllDataSuccessState) {
              if (state.listData.isNotEmpty) {
                Provider.of<StatisticProvider>(context, listen: false)
                    .updateStatisticDTO(state.listData.first);
              }
            }
          }, builder: (context, state) {
            if (state is StatisticGetAllDataSuccessState) {
              return ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 40, 4, 12),
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColor.WHITE),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: StatisticalLineChart(
                          listData: state.listData,
                        )),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20, left: 4),
                          child: Text(
                            'Thời gian\n(Tháng)',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10),
                          ),
                        )
                      ],
                    ),
                  ),
                  _buildOverView(state.dto, state.listData),
                  const SizedBox(
                    height: 24,
                  ),
                  if (state.listData.isNotEmpty)
                    LineChart(
                      listData: state.listData,
                    ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              );
            }
            return ListView(
              padding: const EdgeInsets.only(top: 12),
              children: [_buildOverView(dto, [])],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildOverView(
      ResponseStatisticDTO dto, List<ResponseStatisticDTO> listData) {
    return Consumer<StatisticProvider>(builder: (context, provider, child) {
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
          Row(
            children: [
              Transform.scale(
                scale: 0.9,
                child: Radio<TypeStatistical>(
                  value: TypeStatistical.all,
                  activeColor: AppColor.BLUE_TEXT,
                  groupValue: provider.typeStatistical,
                  onChanged: (TypeStatistical? type) {
                    provider.updateTypeStatistical(type!);
                  },
                ),
              ),
              const Text(
                'Tất cả',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(
                width: 16,
              ),
              if (listData.isNotEmpty) ...[
                Transform.scale(
                  scale: 0.9,
                  child: Radio<TypeStatistical>(
                    value: TypeStatistical.month,
                    activeColor: AppColor.BLUE_TEXT,
                    groupValue: provider.typeStatistical,
                    onChanged: (TypeStatistical? type) {
                      provider.updateTypeStatistical(type!);
                    },
                  ),
                ),
                DropdownButton<ResponseStatisticDTO>(
                  value: provider.responseStatisticDTO,
                  elevation: 16,
                  style:
                      const TextStyle(color: AppColor.BLUE_TEXT, fontSize: 12),
                  onChanged: (ResponseStatisticDTO? dto) {
                    provider.updateStatisticDTO(dto!);
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: AppColor.BLUE_TEXT,
                  ),
                  underline: const SizedBox.shrink(),
                  items: listData.map<DropdownMenuItem<ResponseStatisticDTO>>(
                      (ResponseStatisticDTO dto) {
                    return DropdownMenuItem<ResponseStatisticDTO>(
                      value: dto,
                      child: Text(dto.month),
                    );
                  }).toList(),
                ),
              ]
            ],
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
                _buildItemOverView(
                    provider.typeStatistical == TypeStatistical.all
                        ? dto.totalTrans.toString()
                        : provider.responseStatisticDTO.totalTrans.toString(),
                    title: 'Tổng quan'),
                _buildItemOverView(
                    provider.typeStatistical == TypeStatistical.all
                        ? dto.totalTransC.toString()
                        : provider.responseStatisticDTO.totalTransC.toString(),
                    title: 'Nhận tiền đến'),
                _buildItemOverView(
                    provider.typeStatistical == TypeStatistical.all
                        ? dto.totalTransD.toString()
                        : provider.responseStatisticDTO.totalTransD.toString(),
                    title: 'Chuyển tiền đi')
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          _buildTotal(provider.typeStatistical == TypeStatistical.all
              ? dto
              : provider.responseStatisticDTO)
        ],
      );
    });
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
