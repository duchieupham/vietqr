import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/statistical_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_detail/blocs/statistical_bloc.dart';
import 'package:vierqr/features/bank_detail/events/statistical_event.dart';
import 'package:vierqr/features/bank_detail/states/statistical_state.dart';
import 'package:vierqr/features/bank_detail/views/bottom_sheet_statistical.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/statistical_dto.dart';
import 'package:vierqr/models/terminal_response_dto.dart';
import 'package:vierqr/services/providers/statistical_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import '../views/line_chart_custom.dart';

class StatisticalScreen extends StatelessWidget {
  final String bankId;
  final TerminalDto? terminalDto;
  final AccountBankDetailDTO? bankDetailDTO;

  StatisticalScreen(
      {Key? key, required this.bankId, this.terminalDto, this.bankDetailDTO})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StatisticProvider(
          bankDetailDTO?.userId == UserHelper.instance.getUserId())
        ..updateData(
          listTerminal: terminalDto?.terminals ?? [],
          dateTimeFilter: DateTime.now(),
          terminal: TerminalResponseDTO(banks: []),
          isFirst: true,
          keySearchParent: '',
        ),
      child: BlocProvider<StatisticBloc>(
        create: (context) => StatisticBloc(terminalDto, bankId),
        child: Statistical(bankDetailDTO: bankDetailDTO),
      ),
    );
  }
}

// ignore: must_be_immutable
class Statistical extends StatefulWidget {
  final AccountBankDetailDTO? bankDetailDTO;

  Statistical({Key? key, this.bankDetailDTO}) : super(key: key);

  @override
  State<Statistical> createState() => _StatisticalState();
}

class _StatisticalState extends State<Statistical> {
  ResponseStatisticDTO dto = ResponseStatisticDTO();

  late StatisticBloc _bloc;
  late StatisticProvider _provider;

  DateFormat _dateFormat = DateFormat('yyyy-MM');

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _provider = Provider.of<StatisticProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(StatisticEventGetData(
          terminalCode: '', month: _dateFormat.format(DateTime.now())));
      _bloc.add(StatisticEventGetOverview(
          terminalCode: '', month: _dateFormat.format(DateTime.now())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StatisticBloc, StatisticState>(
      listener: (context, state) {
        if (state.request == StatisticType.GET_SINGLE_DTO) {
          _provider.updateStatisticDTO(state.statisticDTO);
        }
      },
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              ...[
                const SizedBox(height: 16),
                Consumer<StatisticProvider>(
                    builder: (context, provider, child) {
                  return Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text('Biểu đồ thống kê giao dịch',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            Text(
                              provider.getDateParent,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => _onFilter(context, provider),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: AppColor.BLUE_TEXT.withOpacity(0.3)),
                            child: Image.asset(
                              'assets/images/ic-filter-blue.png',
                              height: 28,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }),
                const SizedBox(height: 16),
                LineChartCustom(
                  listData: state.listStatistics,
                  listSeparate: state.listSeparate,
                  dateTime: _provider.dateFilter,
                )
              ],
              _buildOverView(state.statisticDTO, state.listStatistics),
              const SizedBox(height: 24),
              const SizedBox(height: 60),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverView(
      ResponseStatisticDTO dto, List<ResponseStatisticDTO> listData) {
    return Consumer<StatisticProvider>(
      builder: (context, provider, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dữ liệu thống kê được ghi nhận bắt đầu từ thời điểm tài khoản ngân hàng của bạn kết nối với hệ thống VietQR VN',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 16),
                SizedBox(
                  height: 8,
                  width: 30,
                  child: Stack(
                    children: [
                      Center(
                          child: Container(
                              height: 1, width: 30, color: AppColor.GREEN)),
                      Positioned.fill(
                        child: Row(
                          children: [
                            Expanded(child: SizedBox()),
                            CircleAvatar(
                                radius: 4, backgroundColor: AppColor.GREEN),
                            Expanded(child: SizedBox()),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text('Giao dịch đến', style: TextStyle(fontSize: 11)),
                const SizedBox(width: 24),
                Container(
                  height: 8,
                  width: 30,
                  child: Stack(
                    children: [
                      Center(
                          child: Container(
                              height: 1, width: 30, color: AppColor.RED_TEXT)),
                      Positioned.fill(
                        child: Row(
                          children: [
                            Expanded(child: SizedBox()),
                            CircleAvatar(
                                radius: 4, backgroundColor: AppColor.RED_TEXT),
                            Expanded(child: SizedBox()),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text('Giao dịch đi', style: TextStyle(fontSize: 11)),
              ],
            ),
            const SizedBox(height: 24),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            provider.getDateParent,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          const Spacer(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                  provider.typeStatistical ==
                                          TypeStatistical.all
                                      ? dto.totalTrans.toString()
                                      : provider.responseStatisticDTO.totalTrans
                                          .toString(),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.BLUE_TEXT)),
                              const SizedBox(width: 4),
                            ],
                          ),
                          const Text('giao dịch',
                              style: TextStyle(
                                  fontSize: 12, color: AppColor.GREY_TEXT)),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TK ngân hàng', style: TextStyle(fontSize: 12)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              height: 26,
                              width: 45,
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppColor.gray),
                                  image: DecorationImage(
                                      image: ImageUtils.instance
                                          .getImageNetWork(
                                              widget.bankDetailDTO?.imgId ??
                                                  ''))),
                            ),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.bankDetailDTO?.bankAccount ?? '',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    '${widget.bankDetailDTO?.userBankName ?? ''}'
                                        .toUpperCase(),
                                    style: TextStyle(fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        if (provider.isOwner &&
                            provider.terminalResponseDTO.id.isEmpty &&
                            provider.keySearch !=
                                provider.terminalResponseDTO.code)
                          Text('Chi nhánh ${provider.keySearch}',
                              style: TextStyle(
                                  fontSize: 11, color: AppColor.GREY_TEXT))
                        else if ((provider.isOwner &&
                                provider.terminalResponseDTO.id.isNotEmpty) ||
                            (!provider.isOwner &&
                                provider.terminalResponseDTO.id.isNotEmpty))
                          Text('Chi nhánh ${provider.terminalResponseDTO.code}',
                              style: TextStyle(
                                  fontSize: 11, color: AppColor.GREY_TEXT))
                        else
                          const Text('Ghi nhận tất cả giao dịch',
                              style: TextStyle(
                                  fontSize: 11, color: AppColor.GREY_TEXT)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColor.WHITE),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildItemOverView(
                    provider.responseStatisticDTO.totalTransC.toString(),
                    title: 'Nhận tiền đến',
                    totalCashIn: dto.totalCashIn,
                  ),
                  const SizedBox(height: 16),
                  _buildItemOverView(
                    provider.responseStatisticDTO.totalTransD.toString(),
                    title: 'Chuyển tiền đi',
                    totalCashIn: provider.responseStatisticDTO.totalCashOut,
                    color: AppColor.RED_TEXT,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        );
      },
    );
  }

  Widget _buildItemOverView(
    String value, {
    required String title,
    totalCashIn,
    Color? color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: color ?? AppColor.GREEN,
              ),
            ),
            const SizedBox(width: 4),
            const Text('giao dịch',
                style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT)),
            const SizedBox(width: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  StringUtils.formatNumber(totalCashIn),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: color ?? AppColor.GREEN),
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
      ],
    );
  }

  void _onFilter(BuildContext context, StatisticProvider provider) async {
    await DialogWidget.instance.showModelBottomSheet(
      isDismissible: true,
      margin: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(16),
      widget: BottomSheetStatistical(
        listTerminal: provider.terminals,
        dateFilter: provider.dateFilter,
        terminalDto: provider.terminalResponseDTO,
        keySearch: provider.keySearch,
        isOwner: provider.isOwner,
        reset: () {
          provider.onReset();
          _bloc.add(StatisticEventGetData(
              terminalCode: '', month: _dateFormat.format(DateTime.now())));
          _bloc.add(StatisticEventGetOverview(
              terminalCode: '', month: _dateFormat.format(DateTime.now())));
        },
        onApply: (dateTime, terminal, keySearch) {
          provider.updateDateFilter(dateTime);
          provider.updateTerminalResponseDTO(terminal);
          provider.updateKeyword(keySearch);
          String terminalCode = terminal.code;
          if (terminal.id.isEmpty && keySearch == terminal.code) {
            terminalCode = '';
          }
          if (keySearch != terminal.code && provider.isOwner) {
            terminalCode = keySearch;
          }
          _bloc.add(StatisticEventGetData(
              terminalCode: terminalCode, month: _dateFormat.format(dateTime)));
          _bloc.add(StatisticEventGetOverview(
              terminalCode: terminalCode, month: _dateFormat.format(dateTime)));
        },
      ),
    );
  }
}
