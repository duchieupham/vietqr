import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';

class AnimationGraphWidget extends StatefulWidget {
  final ValueNotifier<bool> scrollNotifer;
  const AnimationGraphWidget({super.key, required this.scrollNotifer});

  @override
  State<AnimationGraphWidget> createState() => _AnimationGraphWidgetState();
}

class _AnimationGraphWidgetState extends State<AnimationGraphWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  final List<Transaction> transactions = [
    Transaction(amount: '+ 15,000', time: '18:20', color: Colors.green),
    Transaction(amount: '+ 20,000', time: '18:00', color: Colors.orange),
    Transaction(amount: '- 32,000', time: '15:00', color: Colors.red),
    Transaction(amount: '+ 320,000', time: '09:00', color: Colors.green),
    Transaction(amount: '- 86,000', time: '09/07/2024', color: Colors.red),
  ];
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  double calculateMaxAmount(double totalAmount) {
    if (totalAmount <= 50000000) {
      return 50000000;
    } else if (totalAmount <= 100000000) {
      return 100000000;
    } else if (totalAmount <= 150000000) {
      return 150000000;
    } else if (totalAmount <= 200000000) {
      return 200000000;
    } else {
      return (totalAmount * 1.2).roundToDouble(); // 20% more than totalAmount
    }
  }

  bool isFiftyPercent(double currentAmount, double totalAmount) {
    if (totalAmount == 0) return false; // To handle division by zero
    return currentAmount == (0.5 * totalAmount);
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount1 = 180300000; // Example total amount
    double totalAmount2 = 90200000; // Example total amount

    double maxAmount1 = calculateMaxAmount(totalAmount1);
    double maxAmount2 = calculateMaxAmount(totalAmount1);

    return ValueListenableBuilder<bool>(
      valueListenable: widget.scrollNotifer,
      builder: (context, value, child) {
        if (value == true) {
          _controller.forward();
        }
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              height: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Biểu đồ thu chi',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    '07/2024',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColor.GREY_TEXT),
                                  ),
                                ],
                              ),
                              // const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  AnimatedBar(
                                    animation: _animation,
                                    totalAmount: totalAmount1,
                                    currentAmount: 15800000, // in VND
                                    maxAmount:
                                        maxAmount1, // Dynamically calculated max amount
                                    color: AppColor.GREEN.withOpacity(0.2),
                                  ),
                                  const SizedBox(width: 20),
                                  AnimatedBar(
                                    animation: _animation,
                                    totalAmount: totalAmount2,
                                    currentAmount: 50000000, // in VND
                                    maxAmount:
                                        maxAmount2, // Dynamically calculated max amount
                                    color: Colors.red.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Container(
                                height: 30,
                                width: 150,
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
                                    'Chi tiết thống kê',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColor.BLUE_TEXT),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    text: TextSpan(
                                        text:
                                            StringUtils.formatNumber(120000000),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColor.GREEN,
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
                                  '12,049 GD đến (+)',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppColor.BLACK,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),
                                RichText(
                                    text: TextSpan(
                                        text:
                                            StringUtils.formatNumber(90000000),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColor.RED_TEXT,
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
                                  '1,023 GD đi (-)',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppColor.BLACK,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 16,
                                      color: AppColor.GREEN,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Giao dịch đến (+)',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColor.BLACK,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 16,
                                      color: AppColor.RED_TEXT,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Giao dịch đến (-)',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColor.BLACK,
                                          fontWeight: FontWeight.normal),
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
                    text: TextSpan(
                        text: 'Còn ',
                        style: TextStyle(fontSize: 12, color: AppColor.BLACK),
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
                  // Text(
                  //   'Còn 12 ngày nữa sang chu kỳ mới',
                  //   style: TextStyle(fontSize: 12),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 320,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Số tiền (VND)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(
                          'Thời gian',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: const MySeparator(
                      color: AppColor.GREY_DADADA,
                    ),
                  ),
                  for (var transaction in transactions) ...[
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            transaction.amount,
                            style: TextStyle(
                                color: transaction.color, fontSize: 12),
                          ),
                          Text(
                            transaction.time,
                            style: const TextStyle(
                                color: AppColor.BLACK, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: const MySeparator(
                        color: AppColor.GREY_DADADA,
                      ),
                    ),
                  ]
                ],
              ),
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
    double barHeight = (totalAmount / maxAmount) * maxHeight;
    double currentHeight =
        currentAmount != 0 ? (currentAmount / totalAmount) * barHeight : 6;
    bool isFiftyPercent = currentHeight >= barHeight * 0.7;
    String formatAmount(double amount) {
      double billions = amount / 1000000;
      return '${billions.toStringAsFixed(1).replaceAll('.', ',')} Tr';
    }

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
