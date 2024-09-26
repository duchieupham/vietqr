import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
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
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/statistical_provider.dart';

import '../views/line_chart_custom.dart';

class StatisticalScreen extends StatelessWidget {
  final String bankId;
  final TerminalDto? terminalDto;
  final AccountBankDetailDTO? bankDetailDTO;

  const StatisticalScreen(
      {super.key, required this.bankId, this.terminalDto, this.bankDetailDTO});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StatisticProvider(
          bankDetailDTO?.userId == SharePrefUtils.getProfile().userId)
        ..updateData(
          listTerminal: terminalDto?.terminals ?? [],
          dateTimeFilter: DateTime.now(),
          timeDayParent: DateTime.now(),
          terminal: TerminalResponseDTO(banks: []),
          isFirst: true,
          keySearchParent: '',
          codeSearchParent: '',
          listStatusData: [
            StatisticStatusData(type: 0, name: 'Ngày'),
            StatisticStatusData(type: 1, name: 'Tháng'),
          ],
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

  const Statistical({super.key, this.bankDetailDTO});

  @override
  State<Statistical> createState() => _StatisticalState();
}

class _StatisticalState extends State<Statistical> {
  ResponseStatisticDTO dto = ResponseStatisticDTO();

  late StatisticBloc _bloc;
  late StatisticProvider _provider;

  final DateFormat _dateFormat = DateFormat('yyyy-MM');
  final DateFormat _dateFormatDay = DateFormat('yyyy-MM-dd HH:mm:ss');

  DateTime _fromDate(DateTime now) {
    DateTime fromDate = DateTime(now.year, now.month, now.day);
    return fromDate;
  }

  DateTime _endDate(DateTime now) {
    DateTime fromDate = _fromDate(now);
    return fromDate
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _provider = Provider.of<StatisticProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(StatisticEventGetData(
        terminalCode: '',
        toDate: _dateFormatDay.format(_endDate(DateTime.now())),
        fromDate: _dateFormatDay.format(_fromDate(DateTime.now())),
        type: 0,
      ));
      _bloc.add(StatisticEventGetOverview(
        terminalCode: '',
        toDate: _dateFormatDay.format(_endDate(DateTime.now())),
        fromDate: _dateFormatDay.format(_fromDate(DateTime.now())),
        type: 0,
      ));
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
        return Stack(
          children: [
            Container(
              color: Colors.white,
              child: RefreshIndicator(
                onRefresh: _onRefresh,
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
                                  const Text('Biểu đồ thống kê giao dịch',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  Text(_terminalTitleName(provider),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  Text(
                                    provider.typeTimeDay
                                        ? provider.getParentTimeDay
                                        : provider.getDateParent,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
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
                                      color:
                                          AppColor.BLUE_TEXT.withOpacity(0.3)),
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
                      Stack(
                        children: [
                          LineChartCustom(
                            listData: state.listStatistics,
                            listSeparate: state.listSeparate,
                            type: _provider.statisticStatusData.type,
                          ),
                          Visibility(
                            visible: state.status == BlocStatus.LOADING_PAGE,
                            child: Container(
                              height: 340,
                              color: Colors.grey.withOpacity(0.3),
                              margin: const EdgeInsets.only(left: 40),
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(),
                            ),
                          )
                        ],
                      )
                    ],
                    _buildOverView(state.statisticDTO, state.listStatistics),
                    const SizedBox(height: 24),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
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
                      const Positioned.fill(
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
                const Text('Giao dịch đến', style: TextStyle(fontSize: 11)),
                const SizedBox(width: 24),
                SizedBox(
                  height: 8,
                  width: 30,
                  child: Stack(
                    children: [
                      Center(
                          child: Container(
                              height: 1, width: 30, color: AppColor.RED_TEXT)),
                      const Positioned.fill(
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
                const Text('Giao dịch đi', style: TextStyle(fontSize: 11)),
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
                            provider.typeTimeDay
                                ? provider.getParentTimeDay
                                : provider.getDateParent,
                            style: const TextStyle(
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
                        const Text('TK ngân hàng', style: TextStyle(fontSize: 12)),
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.bankDetailDTO?.bankAccount ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                      (widget.bankDetailDTO?.userBankName ?? '')
                                          .toUpperCase(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 11)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(_terminalName(provider),
                            style: const TextStyle(
                                fontSize: 11, color: AppColor.GREY_TEXT))
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

  String _terminalName(StatisticProvider provider) {
    if (provider.isOwner &&
        provider.terminalResponseDTO.id.isEmpty &&
        provider.codeSearch != provider.terminalResponseDTO.code) {
      return 'Cửa hàng ${provider.keySearch}';
    } else if ((provider.isOwner &&
            provider.terminalResponseDTO.id.isNotEmpty) ||
        (!provider.isOwner && provider.terminalResponseDTO.id.isNotEmpty)) {
      return 'Cửa hàng ${provider.terminalResponseDTO.name}';
    } else {
      return 'Ghi nhận tất cả giao dịch';
    }
  }

  String _terminalTitleName(StatisticProvider provider) {
    if (provider.isOwner &&
        provider.terminalResponseDTO.id.isEmpty &&
        provider.codeSearch != provider.terminalResponseDTO.code) {
      return provider.keySearch;
    } else if ((provider.isOwner &&
            provider.terminalResponseDTO.id.isNotEmpty) ||
        (!provider.isOwner && provider.terminalResponseDTO.id.isNotEmpty)) {
      return provider.terminalResponseDTO.name;
    } else {
      return 'Tất cả';
    }
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
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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
      margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      borderRadius: BorderRadius.circular(16),
      widget: BottomSheetStatistical(
        listTerminal: provider.terminals,
        dateFilter: provider.dateFilter,
        terminalDto: provider.terminalResponseDTO,
        keySearch: provider.keySearch,
        statusData: provider.statisticStatusData,
        timeDay: provider.timeDay,
        codeSearch: provider.codeSearch,
        isOwner: provider.isOwner,
        listStatusData: provider.listStatisticStatus,
        reset: () {
          provider.onReset();
          int type = provider.statisticStatusData.type;

          String fromDate = type == 0
              ? _dateFormatDay.format(_fromDate(DateTime.now()))
              : _dateFormat.format(DateTime.now());
          String endDate = type == 0
              ? _dateFormatDay.format(_endDate(DateTime.now()))
              : _dateFormat.format(DateTime.now());

          _bloc.add(
            StatisticEventGetData(
              terminalCode: '',
              toDate: endDate,
              fromDate: fromDate,
              type: type,
            ),
          );
          _bloc.add(StatisticEventGetOverview(
              terminalCode: '',
              toDate: endDate,
              fromDate: fromDate,
              type: type));
        },
        onApply:
            (dateTime, timeDay, terminal, codeSearch, keySearch, statusData) {
          provider.updateDateFilter(dateTime);
          provider.updateKeyword(keySearch);
          provider.updateCodeSearch(codeSearch);
          provider.updateStatusData(statusData);
          provider.updateTerminalResponseDTO(terminal, isUpdate: true);
          provider.updateTimeDay(timeDay);
          String terminalCode = terminal.code;
          if (terminal.id.isEmpty && codeSearch == terminal.code) {
            terminalCode = '';
          }
          if (codeSearch != terminal.code && provider.isOwner) {
            terminalCode = codeSearch;
          }
          int type = provider.statisticStatusData.type;
          DateTime date = type == 0 ? timeDay : dateTime;

          String fromDate = type == 0
              ? _dateFormatDay.format(_fromDate(date))
              : _dateFormat.format(date);
          String endDate = type == 0
              ? _dateFormatDay.format(_endDate(date))
              : _dateFormat.format(date);

          _bloc.add(StatisticEventGetData(
            terminalCode: terminalCode,
            toDate: endDate,
            fromDate: fromDate,
            type: type,
          ));
          _bloc.add(StatisticEventGetOverview(
            terminalCode: terminalCode,
            toDate: endDate,
            fromDate: fromDate,
            type: type,
          ));
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    final provider = Provider.of<StatisticProvider>(context, listen: false);
    int type = provider.statisticStatusData.type;

    DateTime dateTime = type == 0 ? provider.timeDay : provider.dateFilter;
    TerminalResponseDTO terminal = provider.terminalResponseDTO;
    String codeSearch = provider.codeSearch;
    String terminalCode = terminal.code;

    if (terminal.id.isEmpty && codeSearch == terminal.code) {
      terminalCode = '';
    }
    if (codeSearch != terminal.code && provider.isOwner) {
      terminalCode = codeSearch;
    }

    String fromDate = type == 0
        ? _dateFormatDay.format(_fromDate(dateTime))
        : _dateFormat.format(dateTime);
    String endDate = type == 0
        ? _dateFormatDay.format(_endDate(dateTime))
        : _dateFormat.format(dateTime);

    _bloc.add(
      StatisticEventGetData(
        terminalCode: terminalCode,
        toDate: endDate,
        fromDate: fromDate,
        type: type,
      ),
    );
    _bloc.add(StatisticEventGetOverview(
      terminalCode: terminalCode,
      toDate: endDate,
      fromDate: fromDate,
      type: type,
    ));
  }
}
