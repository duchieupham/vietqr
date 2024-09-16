import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/features/bank_card/widgets/latest_trans_widget.dart';
import 'package:vierqr/features/bank_detail_new/widgets/filter_time_widget.dart';
import 'package:vierqr/features/my_vietqr/widgets/select_store_widget.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_overview_dto.dart';
import 'package:vierqr/models/vietqr_store_dto.dart';

class AnimationGraphWidget extends StatefulWidget {
  final BankAccountDTO dto;
  final ValueNotifier<bool> scrollNotifer;
  final Function() onTap;
  final bool isHome;
  final EdgeInsetsGeometry? margin;

  const AnimationGraphWidget({
    super.key,
    required this.scrollNotifer,
    required this.dto,
    required this.onTap,
    this.isHome = false,
    this.margin,
  });

  @override
  State<AnimationGraphWidget> createState() => _AnimationGraphWidgetState();
}

class _AnimationGraphWidgetState extends State<AnimationGraphWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  final BankBloc bankBloc = getIt.get<BankBloc>();
  bool isLoading = false;
  VietQRStoreDTO merchant = VietQRStoreDTO(terminals: []);

  //   await DialogWidget.instance
  //     .showModelBottomSheet(
  //   borderRadius: BorderRadius.circular(0),
  //   width: MediaQuery.of(context).size.width,
  //   height: MediaQuery.of(context).size.height * 0.57,
  //   padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
  //   bgrColor: AppColor.WHITE,
  //   margin: EdgeInsets.zero,
  //   widget: SelectStoreWidget(
  //     bankId: selectBank.id,
  //   ),
  // )
  //     .then(
  //   (value) {
  //     if (value != null) {}
  //   },
  // );

  String getSession() {
    DateTime now = DateTime.now();
    DateTime fromDate = DateTime(now.year, now.month, 1);
    if (now.month >= 1 && now.month <= 3) {
      DateTime currentSesson = DateTime(now.year, 1, 1);
      if (fromDate.isBefore(currentSesson)) {
        return '${DateFormat('yyyy-MM-dd').format(currentSesson)} 00:00:00';
      }
      return '${DateFormat('yyyy-MM-dd').format(fromDate)} 00:00:00';
    } else if (now.month >= 4 && now.month <= 6) {
      DateTime currentSesson = DateTime(now.year, 4, 1);
      if (fromDate.isBefore(currentSesson)) {
        return '${DateFormat('yyyy-MM-dd').format(currentSesson)} 00:00:00';
      }
      return '${DateFormat('yyyy-MM-dd').format(fromDate)} 00:00:00';
    } else if (now.month >= 7 && now.month <= 9) {
      DateTime currentSesson = DateTime(now.year, 7, 1);
      if (fromDate.isBefore(currentSesson)) {
        return '${DateFormat('yyyy-MM-dd').format(currentSesson)} 00:00:00';
      }
      // Quý 3: Từ 01-07 đến 30-09
      return '${DateFormat('yyyy-MM-dd').format(fromDate)} 00:00:00';
    } else {
      DateTime currentSesson = DateTime(now.year, 10, 1);
      if (fromDate.isBefore(currentSesson)) {
        return '${DateFormat('yyyy-MM-dd').format(currentSesson)} 00:00:00';
      }
      // Quý 4: Từ 01-10 đến 31-12
      return '${DateFormat('yyyy-MM-dd').format(fromDate)} 00:00:00';
    }
  }

  List<FilterTrans> list = [
    FilterTrans(
        title: 'Ngày',
        type: 1,
        fromDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 00:00:00',
        toDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59'),
    FilterTrans(
        title: 'Tuần',
        type: 2,
        fromDate:
            '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 7)))} 00:00:00',
        toDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59'),
    FilterTrans(
        title: 'Tháng',
        type: 3,
        fromDate:
            '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 30)))} 00:00:00',
        toDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59'),
  ];

  FilterTrans selected = FilterTrans(
      title: 'Ngày',
      type: 1,
      fromDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 00:00:00',
      toDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59');

  BankOverviewDTO _currentOverview = BankOverviewDTO();
  BankOverviewDTO get currentOverview => _currentOverview;

  BankOverviewDTO _passedOverview = BankOverviewDTO();
  BankOverviewDTO get passedOverview => _passedOverview;

  bool isTapped = false;

  ValueNotifier<String> stringNotifier =
      ValueNotifier<String>(DateFormat('dd/MM/yyyy').format(DateTime.now()));

  @override
  void initState() {
    super.initState();

    if (!widget.isHome) {
      bankBloc.add(GetTransEvent(bankId: widget.dto.id));
    }
    bankBloc
        .add(GetOverviewBankEvent(bankId: widget.dto.id, type: selected.type));

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  double calculateMaxAmount(double totalAmount) {
    // Calculate the number of digits in the totalAmount
    int lengthOfZeros = totalAmount.toInt().toString().length - 1;
    // Calculate the dynamic percentage based on the number of digits
    double percentage = 1 + (lengthOfZeros * 0.1);

    // Calculate the max amount based on the percentage
    return (totalAmount * percentage).roundToDouble();
  }

  bool isFiftyPercent(double currentAmount, double totalAmount) {
    if (totalAmount == 0) return false; // To handle division by zero
    return currentAmount == (0.5 * totalAmount);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.scrollNotifer,
      builder: (context, value, child) {
        if (_controller.isDismissed && value == true) {
          _controller.forward();
        }
        // if ((_controller.isCompleted || !_controller.isAnimating) &&
        //     value == false) {
        //   _controller.reset();
        // }
        return BlocConsumer<BankBloc, BankState>(
          bloc: bankBloc,
          listener: (context, state) {
            if (state.status == BlocStatus.LOADING &&
                (state.request == BankType.SELECT_BANK)) {
              merchant = VietQRStoreDTO(terminals: []);

              selected = list.first;
            }
            if (state.status == BlocStatus.LOADING &&
                (state.request == BankType.GET_OVERVIEW ||
                    state.request == BankType.SELECT_BANK)) {
              isLoading = true;
              isTapped = true;
              _controller.reset();
            }
            if (state.status == BlocStatus.SUCCESS &&
                (state.request == BankType.GET_OVERVIEW ||
                    state.request == BankType.SELECT_BANK)) {
              isLoading = false;
              isTapped = false;
              _controller.reset();
              _currentOverview = state.overviewDayDto!;
              _passedOverview = state.overviewMonthDto!;
              _controller.forward();
            }
          },
          builder: (context, state) {
            // if (state.overviewMonthDto == null ||
            //     state.overviewDayDto == null) {
            //   return const SizedBox.shrink();
            // }
            return Column(
              children: [
                Container(
                  margin: widget.margin ??
                      const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      _title(),
                      if (widget.dto.isOwner) _merchant(),
                      SizedBox(
                        height: 220,
                        child: Row(
                          children: [
                            Expanded(
                              child: _chart(state),
                            ),
                            _statistic(state),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                LatestTransWidget(
                  dto: widget.dto,
                  listTrans: state.listTrans,
                  isHome: widget.isHome,
                  onTap: widget.onTap,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _merchant() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () async {
                await DialogWidget.instance
                    .showModelBottomSheet(
                  borderRadius: BorderRadius.circular(0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.57,
                  padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                  bgrColor: AppColor.WHITE,
                  margin: EdgeInsets.zero,
                  widget: SelectStoreWidget(
                    isHome: true,
                    bankId: widget.dto.id,
                  ),
                )
                    .then(
                  (value) {
                    if (value != null) {
                      if (value is VietQRStoreDTO) {
                        setState(() {
                          merchant = value;
                        });
                        _getOverview(
                            selected, stringNotifier, bankBloc, widget.dto,
                            terminalCode:
                                merchant.terminals.first.terminalCode);
                      }
                    }
                  },
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                decoration: BoxDecoration(
                  // color: AppColor.WHITE,
                  gradient: VietQRTheme.gradientColor.lilyLinear,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              text: 'Đại lý:',
                              style: const TextStyle(
                                  fontSize: 12, color: AppColor.BLACK),
                              children: [
                                TextSpan(
                                    text: merchant.merchantName.isEmpty
                                        ? ' Chọn đại lý'
                                        : ' ${merchant.merchantName}',
                                    style: const TextStyle(
                                        // fontWeight: FontWeight.w600,
                                        fontSize: 12)),
                              ])),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      weight: 0.5,
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          merchant.terminals.isEmpty
              ? Expanded(child: Container())
              : Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                    decoration: BoxDecoration(
                      // color: AppColor.WHITE,
                      gradient: VietQRTheme.gradientColor.lilyLinear,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Chi nhánh: ${(merchant.terminals.isEmpty) ? '' : merchant.terminals.first.terminalName} ',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        // const Icon(
                        //   Icons.keyboard_arrow_down,
                        //   size: 20,
                        //   weight: 0.5,
                        // )
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Quản lý giao dịch',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        InkWell(
          onTap: () {
            widget.onTap();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 30,
            // width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFE1EFFF),
                  Color(0xFFE5F9FF),
                ],
                end: Alignment.centerRight,
                begin: Alignment.centerLeft,
              ),
            ),
            child: const Center(
              child: Text(
                "Xem thêm",
                style: TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _getOverview(
      FilterTrans selected, ValueNotifier<String> stringNotifier, bankBloc, dto,
      {String terminalCode = ''}) {
    DateTime now = DateTime.now();
    switch (selected.type) {
      case 1:
        stringNotifier.value = DateFormat('dd/MM/yyyy').format(DateTime.now());
        bankBloc.add(
          GetOverviewBankEvent(
              bankId: dto.id,
              type: selected.type,
              fromDate: selected.fromDate,
              toDate: selected.toDate,
              terminalCode: terminalCode),
        );
        break;
      case 2:
        String fromDate = '';
        int currentWeekday = now.weekday;
        DateTime firstDayOfWeek =
            now.subtract(Duration(days: currentWeekday - 1));
        if (firstDayOfWeek.isBefore(DateTime(now.year, 1, 1))) {
          firstDayOfWeek = DateTime(now.year, 1, 1);
        }
        fromDate =
            '${DateFormat('yyyy-MM-dd').format(firstDayOfWeek)} 00:00:00';
        stringNotifier.value =
            '${DateFormat('dd/MM/yy').format(firstDayOfWeek)} -> ${DateFormat('dd/MM/yy').format(DateTime.now())}';
        bankBloc.add(
          GetOverviewBankEvent(
              bankId: dto.id,
              type: selected.type,
              fromDate: fromDate,
              toDate: selected.toDate,
              terminalCode: terminalCode),
        );
        break;
      case 3:
        stringNotifier.value = 'Tháng ${now.month}/${now.year}';
        bankBloc.add(
          GetOverviewBankEvent(
              bankId: widget.dto.id,
              type: selected.type,
              fromDate: getSession(),
              toDate: selected.toDate,
              terminalCode: terminalCode),
        );
        break;
      default:
    }
  }

  Widget _chart(BankState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: List.generate(
                list.length,
                (index) {
                  bool isSelect = selected.type == list[index].type;

                  return InkWell(
                    onTap: !isTapped
                        ? () {
                            setState(() {
                              selected = list[index];
                            });
                            // DateTime now = DateTime.now();
                            // switch (selected.type) {
                            //   case 1:
                            //     stringNotifier.value = DateFormat('dd/MM/yyyy')
                            //         .format(DateTime.now());
                            //     bankBloc.add(
                            //       GetOverviewBankEvent(
                            //           bankId: widget.dto.id,
                            //           type: selected.type,
                            //           fromDate: selected.fromDate,
                            //           toDate: selected.toDate),
                            //     );
                            //     break;
                            //   case 2:
                            //     String fromDate = '';
                            //     int currentWeekday = now.weekday;
                            //     DateTime firstDayOfWeek = now.subtract(
                            //         Duration(days: currentWeekday - 1));
                            //     if (firstDayOfWeek
                            //         .isBefore(DateTime(now.year, 1, 1))) {
                            //       firstDayOfWeek = DateTime(now.year, 1, 1);
                            //     }
                            //     fromDate =
                            //         '${DateFormat('yyyy-MM-dd').format(firstDayOfWeek)} 00:00:00';
                            //     stringNotifier.value =
                            //         '${DateFormat('dd/MM/yy').format(firstDayOfWeek)} -> ${DateFormat('dd/MM/yy').format(DateTime.now())}';
                            //     bankBloc.add(
                            //       GetOverviewBankEvent(
                            //           bankId: widget.dto.id,
                            //           type: selected.type,
                            //           fromDate: fromDate,
                            //           toDate: selected.toDate),
                            //     );
                            //     break;
                            //   case 3:
                            //     stringNotifier.value =
                            //         'Tháng ${now.month}/${now.year}';
                            //     bankBloc.add(
                            //       GetOverviewBankEvent(
                            //           bankId: widget.dto.id,
                            //           type: selected.type,
                            //           fromDate: getSession(),
                            //           toDate: selected.toDate),
                            //     );
                            //     break;
                            //   default:
                            // }
                            _getOverview(
                                selected, stringNotifier, bankBloc, widget.dto,
                                terminalCode:
                                    merchant.terminals.first.terminalCode);
                          }
                        : null,
                    child: Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: isSelect
                              ? VietQRTheme.gradientColor.lilyLinear
                              : null),
                      child: Center(
                        child: Text(
                          list[index].title,
                          style: TextStyle(
                              fontSize: 12,
                              color: isSelect
                                  ? AppColor.BLACK
                                  : AppColor.GREY_TEXT),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
        // const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AnimatedBar(
              isLoading: isLoading,
              type: selected.type,
              animation: _animation,
              totalAmount: double.parse(passedOverview.totalCredit.toString()),
              currentAmount: isLoading
                  ? 0.0
                  : double.parse(
                      currentOverview.totalCredit.toString()), // in VND
              maxAmount: calculateMaxAmount(double.parse(passedOverview
                  .totalCredit
                  .toString())), // Dynamically calculated max amount
              color: AppColor.GREEN.withOpacity(0.2),
            ),
            const SizedBox(width: 20),
            AnimatedBar(
              isLoading: isLoading,
              type: selected.type,
              animation: _animation,
              totalAmount: double.parse(passedOverview.totalDebit.toString()),
              currentAmount: isLoading
                  ? 0.0
                  : double.parse(
                      currentOverview.totalDebit.toString()), // in VND
              maxAmount: calculateMaxAmount(double.parse(passedOverview
                  .totalDebit
                  .toString())), // Dynamically calculated max amount
              color: Colors.red.withOpacity(0.5),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statistic(BankState state) {
    // if (state.status == BlocStatus.LOADING &&
    //     state.request == BankType.SELECT_BANK) {
    //   return const Column(
    //     crossAxisAlignment: CrossAxisAlignment.end,
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           SizedBox(height: 26),
    //           ShimmerBlock(
    //             height: 12,
    //             width: 70,
    //             borderRadius: 10,
    //           )
    //         ],
    //       ),
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           ShimmerBlock(
    //             height: 12,
    //             width: 30,
    //             borderRadius: 10,
    //           ),
    //           SizedBox(height: 2),
    //           ShimmerBlock(
    //             height: 12,
    //             width: 70,
    //             borderRadius: 10,
    //           ),
    //           SizedBox(height: 10),
    //           ShimmerBlock(
    //             height: 12,
    //             width: 30,
    //             borderRadius: 10,
    //           ),
    //           SizedBox(height: 2),
    //           ShimmerBlock(
    //             height: 12,
    //             width: 70,
    //             borderRadius: 10,
    //           ),
    //         ],
    //       ),
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           ShimmerBlock(
    //             height: 12,
    //             width: 100,
    //             borderRadius: 10,
    //           ),
    //           SizedBox(height: 10),
    //           ShimmerBlock(
    //             height: 12,
    //             width: 100,
    //             borderRadius: 10,
    //           ),
    //         ],
    //       ),
    //     ],
    //   );
    // }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 26),
            ValueListenableBuilder<String>(
              valueListenable: stringNotifier,
              builder: (context, value, child) {
                return Text(
                  value,
                  style:
                      const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                );
              },
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RichText(
                text: TextSpan(
                    text: isLoading
                        ? '...'
                        : StringUtils.formatNumber(currentOverview.totalCredit),
                    style: TextStyle(
                        fontSize: 12,
                        color: isLoading ? AppColor.BLACK : AppColor.GREEN,
                        fontWeight: FontWeight.bold),
                    children: const [
                  TextSpan(
                    text: ' VND',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColor.GREY_TEXT,
                        fontWeight: FontWeight.normal),
                  )
                ])),
            const SizedBox(height: 2),
            Text(
              isLoading
                  ? '0 GD đến (+)'
                  : '${CurrencyUtils.instance.getCurrencyFormatted(currentOverview.countCredit.toString())} GD đến (+)',
              style: const TextStyle(
                  fontSize: 10,
                  color: AppColor.BLACK,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            RichText(
                text: TextSpan(
                    text: isLoading
                        ? '...'
                        : StringUtils.formatNumber(currentOverview.totalDebit),
                    style: TextStyle(
                        fontSize: 12,
                        color: isLoading ? AppColor.BLACK : AppColor.RED_TEXT,
                        fontWeight: FontWeight.bold),
                    children: const [
                  TextSpan(
                    text: ' VND',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColor.GREY_TEXT,
                        fontWeight: FontWeight.normal),
                  )
                ])),
            const SizedBox(height: 2),
            Text(
              isLoading
                  ? '0 GD đi (-)'
                  : '${CurrencyUtils.instance.getCurrencyFormatted(currentOverview.countDebit.toString())} GD đi (-)',
              style: const TextStyle(
                  fontSize: 10,
                  color: AppColor.BLACK,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text(
                  'Giao dịch đến (+)',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColor.BLACK,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.circle,
                  size: 16,
                  color: AppColor.GREEN,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Giao dịch đến (-)',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColor.BLACK,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.circle,
                  size: 16,
                  color: AppColor.RED_TEXT,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class AnimatedBar extends StatelessWidget {
  final double totalAmount;
  final double currentAmount;
  final double maxAmount;
  final Color color;
  final int type;
  final Animation<double> animation;
  final bool isLoading;

  const AnimatedBar({
    super.key,
    required this.totalAmount,
    required this.currentAmount,
    required this.maxAmount,
    required this.color,
    required this.animation,
    required this.type,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    double maxHeight = 120.0; // Fixed maximum height for the bars
    double barHeight =
        totalAmount != 0 ? (totalAmount / maxAmount) * maxHeight : maxHeight;

    double currentHeight =
        currentAmount != 0 ? (currentAmount / totalAmount) * barHeight : 6;
    bool isFiftyPercent = currentHeight >= barHeight * 0.65;
    // String formatAmount(double amount) {
    //   double billions = amount / 1000000;
    //   return isLoading
    //       ? '...'
    //       : '${billions.toStringAsFixed(1).replaceAll('.', ',')} Tr';
    // }

    String currentType = '';
    switch (type) {
      case 1:
        currentType = 'Hôm nay';
        break;
      case 2:
        currentType = 'Tuần này';
        break;
      case 3:
        currentType = 'Tháng ${DateTime.now().month}';
        break;
      default:
    }

    String formatAmount(double amount) {
      // if (amount < 1000) {
      //   return '${amount.toInt()} đ';
      // } else if (amount < 1000000) {
      //   double thousands = amount / 1000;
      //   return '${thousands.toStringAsFixed(thousands == thousands.toInt() ? 0 : 1).replaceAll('.', ',')} ngàn';
      // }
      if (isLoading) {
        return '...';
      }
      if (amount < 1000000000) {
        double millions = amount / 1000000;
        return '${millions.toStringAsFixed(millions == millions.toInt() ? 0 : 1).replaceAll('.', ',')} tr';
      } else {
        double billions = amount / 1000000000;
        return '${billions.toStringAsFixed(billions == billions.toInt() ? 0 : 1).replaceAll('.', ',')} tỷ';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type == 3
              ? 'Quý ${(((DateTime.now().month - 1) ~/ 3) + 1).toString()} / ${DateTime.now().year}'
              : 'Tháng ${DateTime.now().month}',
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 10, color: AppColor.GREY_TEXT),
        ),
        Text(
          formatAmount(totalAmount),
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return SizedBox(
              width: 80,
              height: barHeight,
              child: Stack(
                children: [
                  Container(
                    width: 80,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isFiftyPercent) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentType,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(fontSize: 10),
                                ),
                                Text(
                                  formatAmount(currentAmount),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 1),
                        ],
                        Container(
                          width: 80,
                          height: currentHeight * animation.value,
                          decoration: BoxDecoration(
                              color: color.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(4)),
                          alignment: Alignment.center,
                          child: isFiftyPercent
                              ? SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        currentType,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColor.WHITE,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        formatAmount(currentAmount),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColor.WHITE,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class Transaction {
  final String amount;
  final String time;
  final Color color;

  Transaction({required this.amount, required this.time, required this.color});
}
