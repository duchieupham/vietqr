import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/widgets/latest_trans_widget.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/features/bank_detail/states/bank_card_state.dart';
import 'package:vierqr/features/bank_detail_new/widgets/filter_time_widget.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_overview_dto.dart';

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
  late final BankBloc bankBloc = getIt.get<BankBloc>();
  late final BankCardBloc bankCardBloc =
      getIt.get<BankCardBloc>(param1: widget.dto.id, param2: true);

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

  BankOverviewDTO _currentOverview = BankOverviewDTO(
      totalCredit: 0,
      countCredit: 0,
      totalDebit: 0,
      countDebit: 0,
      merchantName: '',
      terminals: []);
  BankOverviewDTO get currentOverview => _currentOverview;

  BankOverviewDTO _passedOverview = BankOverviewDTO(
      totalCredit: 0,
      countCredit: 0,
      totalDebit: 0,
      countDebit: 0,
      merchantName: '',
      terminals: []);
  BankOverviewDTO get passedOverview => _passedOverview;

  bool isTapped = false;

  @override
  void initState() {
    super.initState();

    if (!widget.isHome) {
      bankBloc.add(GetTransEvent(bankId: widget.dto.id));
    }
    bankCardBloc.add(
        GetOverviewBankCardEvent(bankId: widget.dto.id, type: selected.type));

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
            BlocConsumer<BankCardBloc, BankCardState>(
              bloc: bankCardBloc,
              listener: (context, state) {
                if (state.transRequest == TransManage.LOADING) {
                  isTapped = true;
                  _controller.reset();
                }
                if (state.transRequest == TransManage.GET_TRANS) {
                  _currentOverview = state.overviewDayDto!;
                  _passedOverview = state.overviewMonthDto!;
                  _controller.forward();
                  isTapped = false;
                }
              },
              builder: (context, state) {
                // if (state.overviewMonthDto == null ||
                //     state.overviewDayDto == null) {
                //   return const SizedBox.shrink();
                // }
                return Container(
                  margin: widget.margin ??
                      const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      _title(),
                      if (currentOverview.merchantName.isNotEmpty &&
                          widget.dto.isOwner)
                        _merchant(),
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

  Widget _merchant() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
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
                                  text: ' ${currentOverview.merchantName}',
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
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              decoration: BoxDecoration(
                // color: AppColor.WHITE,
                gradient: VietQRTheme.gradientColor.lilyLinear,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Chi nhánh: ${currentOverview.terminals.join(', ')}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
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

  Widget _chart(BankCardState state) {
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
                            bankCardBloc.add(
                              GetOverviewBankCardEvent(
                                  bankId: widget.dto.id,
                                  type: selected.type,
                                  fromDate: selected.fromDate,
                                  toDate: selected.toDate),
                            );
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
              isLoading: state.transRequest == TransManage.NONE ||
                  state.transRequest == TransManage.LOADING,
              type: selected.type,
              animation: _animation,
              totalAmount: double.parse(passedOverview.totalCredit.toString()),
              currentAmount: state.transRequest == TransManage.LOADING
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
              isLoading: state.transRequest == TransManage.NONE ||
                  state.transRequest == TransManage.LOADING,
              type: selected.type,
              animation: _animation,
              totalAmount: double.parse(passedOverview.totalDebit.toString()),
              currentAmount: state.transRequest == TransManage.LOADING
                  ? 0.0
                  : calculateMaxAmount(double.parse(
                      currentOverview.totalDebit.toString())), // in VND
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

  Widget _statistic(BankCardState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 22),
            Text(
              selected.type == 3
                  ? 'Quý ${(((DateTime.now().month - 1) ~/ 3) + 1).toString()} / ${DateTime.now().year}'
                  : DateFormat('MM/yyyy').format(DateTime.now()),
              style: const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RichText(
                text: TextSpan(
                    text: state.transRequest == TransManage.LOADING
                        ? '...'
                        : StringUtils.formatNumber(passedOverview.totalCredit),
                    style: TextStyle(
                        fontSize: 12,
                        color: state.transRequest == TransManage.LOADING
                            ? AppColor.BLACK
                            : AppColor.GREEN,
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
              state.transRequest == TransManage.LOADING
                  ? '0 GD đến (+)'
                  : '${CurrencyUtils.instance.getCurrencyFormatted(passedOverview.countCredit.toString())} GD đến (+)',
              style: const TextStyle(
                  fontSize: 10,
                  color: AppColor.BLACK,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            RichText(
                text: TextSpan(
                    text: state.transRequest == TransManage.LOADING
                        ? '...'
                        : StringUtils.formatNumber(passedOverview.totalDebit),
                    style: TextStyle(
                        fontSize: 12,
                        color: state.transRequest == TransManage.LOADING
                            ? AppColor.BLACK
                            : AppColor.RED_TEXT,
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
              state.transRequest == TransManage.LOADING
                  ? '0 GD đi (-)'
                  : '${CurrencyUtils.instance.getCurrencyFormatted(passedOverview.countDebit.toString())} GD đi (-)',
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
    bool isFiftyPercent = currentHeight >= barHeight * 0.7;
    String formatAmount(double amount) {
      double billions = amount / 1000000;
      return isLoading
          ? '...'
          : '${billions.toStringAsFixed(1).replaceAll('.', ',')} Tr';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type == 3
              ? 'Quý ${(((DateTime.now().month - 1) ~/ 3) + 1).toString()} / ${DateTime.now().year}'
              : 'Tháng này',
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
                          alignment: Alignment.center,
                          child: isFiftyPercent
                              ? SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Column(
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
