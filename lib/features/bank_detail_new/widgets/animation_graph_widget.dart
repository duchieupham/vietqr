import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/widgets/latest_trans_widget.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/features/bank_detail/states/bank_card_state.dart';
import 'package:vierqr/features/bank_detail_new/widgets/filter_time_widget.dart';

class AnimationGraphWidget extends StatefulWidget {
  final String bankId;

  final ValueNotifier<bool> scrollNotifer;
  final Function() onTap;
  final bool isHome;

  const AnimationGraphWidget({
    super.key,
    required this.scrollNotifer,
    required this.bankId,
    required this.onTap,
    this.isHome = false,
  });

  @override
  State<AnimationGraphWidget> createState() => _AnimationGraphWidgetState();
}

class _AnimationGraphWidgetState extends State<AnimationGraphWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final BankBloc bankBloc = getIt.get<BankBloc>();
  late final BankCardBloc bankCardBloc =
      getIt.get<BankCardBloc>(param1: widget.bankId, param2: true);

  List<FilterTrans> list = [
    FilterTrans(
        title: 'Ngày',
        type: 1,
        fromDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 00:00:00',
        toDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59'),
    FilterTrans(
        title: 'Tháng',
        type: 2,
        fromDate:
            '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 30)))} 00:00:00',
        toDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59'),
    FilterTrans(
        title: 'Tuần',
        type: 3,
        fromDate:
            '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 7)))} 00:00:00',
        toDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59'),
  ];

  FilterTrans selected = FilterTrans(
      title: 'Ngày',
      type: 1,
      fromDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 00:00:00',
      toDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59');

  @override
  void initState() {
    super.initState();
    bankBloc.add(GetTransEvent(bankId: widget.bankId));
    bankCardBloc.add(GetOverviewBankCardEvent(bankId: widget.bankId));
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
        return Column(
          children: [
            BlocBuilder<BankCardBloc, BankCardState>(
              bloc: bankCardBloc,
              builder: (context, state) {
                // if (state.overviewMonthDto == null ||
                //     state.overviewDayDto == null) {
                //   return const SizedBox.shrink();
                // }
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  height: 280,
                  child: state.overviewMonthDto == null ||
                          state.overviewDayDto == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.isHome
                                                  ? 'Quản lý giao dịch'
                                                  : 'Biểu đồ thu chi',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: widget.isHome
                                                      ? FontWeight.bold
                                                      : FontWeight.normal),
                                            ),
                                            if (widget.isHome) ...[
                                              const SizedBox(height: 4),
                                              Row(
                                                children: List.generate(
                                                  list.length,
                                                  (index) {
                                                    bool isSelect =
                                                        selected.type ==
                                                            list[index].type;

                                                    return InkWell(
                                                      onTap: () {},
                                                      child: Container(
                                                        height: 30,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 16),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            gradient: isSelect
                                                                ? VietQRTheme
                                                                    .gradientColor
                                                                    .lilyLinear
                                                                : null),
                                                        child: Center(
                                                          child: Text(
                                                            list[index].title,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: isSelect
                                                                    ? AppColor
                                                                        .BLACK
                                                                    : AppColor
                                                                        .GREY_TEXT),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            ] else
                                              Text(
                                                DateFormat('MM/yyyy')
                                                    .format(DateTime.now()),
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: AppColor.GREY_TEXT),
                                              ),
                                          ],
                                        ),
                                        // const SizedBox(height: 20),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            AnimatedBar(
                                              animation: _animation,
                                              totalAmount: double.parse(state
                                                  .overviewMonthDto!.totalCredit
                                                  .toString()),
                                              currentAmount: double.parse(state
                                                  .overviewDayDto!.totalCredit
                                                  .toString()), // in VND
                                              maxAmount: calculateMaxAmount(
                                                  double.parse(state
                                                      .overviewMonthDto!
                                                      .totalCredit
                                                      .toString())), // Dynamically calculated max amount
                                              color: AppColor.GREEN
                                                  .withOpacity(0.2),
                                            ),
                                            const SizedBox(width: 20),
                                            AnimatedBar(
                                              animation: _animation,
                                              totalAmount: double.parse(state
                                                  .overviewMonthDto!.totalDebit
                                                  .toString()),
                                              currentAmount: calculateMaxAmount(
                                                  double.parse(state
                                                      .overviewDayDto!
                                                      .totalDebit
                                                      .toString())), // in VND
                                              maxAmount: calculateMaxAmount(
                                                  double.parse(state
                                                      .overviewMonthDto!
                                                      .totalDebit
                                                      .toString())), // Dynamically calculated max amount
                                              color:
                                                  Colors.red.withOpacity(0.5),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (widget.isHome) {
                                              } else {}
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              height: 30,
                                              // width: 150,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFFE1EFFF),
                                                    Color(0xFFE5F9FF),
                                                  ],
                                                  end: Alignment.centerRight,
                                                  begin: Alignment.centerLeft,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  widget.isHome
                                                      ? "Xem thêm"
                                                      : 'Chi tiết thống kê',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          AppColor.BLUE_TEXT),
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (widget.isHome) ...[
                                            const SizedBox(height: 8),
                                            Text(
                                              DateFormat('MM/yyyy')
                                                  .format(DateTime.now()),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColor.GREY_TEXT),
                                            ),
                                          ]
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                              text: TextSpan(
                                                  text:
                                                      StringUtils.formatNumber(
                                                          state
                                                              .overviewMonthDto!
                                                              .totalCredit),
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: AppColor.GREEN,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: const [
                                                TextSpan(
                                                  text: ' VND',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppColor.GREY_TEXT,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                )
                                              ])),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${CurrencyUtils.instance.getCurrencyFormatted(state.overviewMonthDto!.countCredit.toString())} GD đến (+)',
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: AppColor.BLACK,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 10),
                                          RichText(
                                              text: TextSpan(
                                                  text:
                                                      StringUtils.formatNumber(
                                                          state
                                                              .overviewMonthDto!
                                                              .totalDebit),
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: AppColor.RED_TEXT,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: const [
                                                TextSpan(
                                                  text: ' VND',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppColor.GREY_TEXT,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                )
                                              ])),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${CurrencyUtils.instance.getCurrencyFormatted(state.overviewMonthDto!.countDebit.toString())} GD đi (-)',
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: AppColor.BLACK,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                size: 16,
                                                color: AppColor.GREEN,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'Giao dịch đến (+)',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColor.BLACK,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                size: 16,
                                                color: AppColor.RED_TEXT,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'Giao dịch đến (-)',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColor.BLACK,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),
                            RichText(
                              text: const TextSpan(
                                  text: 'Còn ',
                                  style: TextStyle(
                                      fontSize: 12, color: AppColor.BLACK),
                                  children: [
                                    TextSpan(
                                        text: '12 ngày nữa ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColor.BLACK,
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: 'sang chu kỳ mới',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColor.BLACK,
                                        )),
                                  ]),
                            )
                          ],
                        ),
                );
              },
            ),
            const SizedBox(height: 20),
            LatestTransWidget(
              isHome: widget.isHome,
              onTap: widget.onTap,
            ),
          ],
        );
      },
    );
  }
}

class AnimatedBar extends StatelessWidget {
  final double totalAmount;
  final double currentAmount;
  final double maxAmount;
  final Color color;
  final Animation<double> animation;

  const AnimatedBar({
    super.key,
    required this.totalAmount,
    required this.currentAmount,
    required this.maxAmount,
    required this.color,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    double maxHeight = 150.0; // Fixed maximum height for the bars
    double barHeight =
        totalAmount != 0 ? (totalAmount / maxAmount) * maxHeight : maxHeight;

    double currentHeight =
        currentAmount != 0 ? (currentAmount / totalAmount) * barHeight : 6;
    bool isFiftyPercent = currentHeight >= barHeight * 0.7;
    String formatAmount(double amount) {
      double billions = amount / 1000000;
      return '${billions.toStringAsFixed(1).replaceAll('.', ',')} Tr';
    }
    // String formatAmount(double amount) {
    //   if (amount < 1000) {
    //     return '${amount.toInt()} đ';
    //   } else if (amount < 1000000) {
    //     double thousands = amount / 1000;
    //     return '${thousands.toStringAsFixed(thousands == thousands.toInt() ? 0 : 1).replaceAll('.', ',')} ngàn';
    //   } else if (amount < 1000000000) {
    //     double millions = amount / 1000000;
    //     return '${millions.toStringAsFixed(millions == millions.toInt() ? 0 : 1).replaceAll('.', ',')} tr';
    //   } else {
    //     double billions = amount / 1000000000;
    //     return '${billions.toStringAsFixed(billions == billions.toInt() ? 0 : 1).replaceAll('.', ',')} tỷ';
    //   }
    // }

    // print(object)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tháng này',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 10, color: AppColor.GREY_TEXT),
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
                                const Text(
                                  'Hôm nay',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 10),
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
                          child: isFiftyPercent
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Hôm nay',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
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
