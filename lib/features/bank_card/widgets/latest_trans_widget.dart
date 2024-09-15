import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/features/bank_detail_new/bank_card_detail_new_screen.dart';
import 'package:vierqr/features/bank_detail_new/views/transaction_detail_screen.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/nearest_transaction_dto.dart';

class LatestTransWidget extends StatefulWidget {
  final Function() onTap;
  final bool isHome;
  final BankAccountDTO dto;

  final List<NearestTransDTO> listTrans;
  const LatestTransWidget({
    super.key,
    required this.onTap,
    required this.isHome,
    required this.dto,
    required this.listTrans,
  });

  @override
  State<LatestTransWidget> createState() => _LatestTransWidgetState();
}

class _LatestTransWidgetState extends State<LatestTransWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          // height: 320,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: widget.isHome
              ? null
              : BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: AppColor.BLACK.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 1))
                  ],
                ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Số tiền (VND)',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 12),
                    ),
                    Text(
                      'Thời gian',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const MySeparator(
                  color: AppColor.GREY_DADADA,
                ),
              ),
              ...widget.listTrans.asMap().map(
                (index, e) {
                  final transaction = widget.listTrans[index];
                  Color color = AppColor.GREEN;

                  switch (transaction.transType) {
                    case "C":
                      switch (transaction.status) {
                        case 0:
                          // - Giao dịch chờ thanh toán
                          color = AppColor.ORANGE_TRANS;
                          break;
                        case 1:
                          switch (transaction.type) {
                            case 2:
                              // - Giao dịch đến (+) không đối soát
                              color = AppColor.BLUE_TEXT;
                              break;
                            default:
                              // - Giao dịch đến (+) có đối soát
                              color = AppColor.GREEN;
                              break;
                          }
                          break;
                        case 2:
                          // Giao dịch hết hạn thanh toán;
                          color = AppColor.GREY_TEXT;
                          break;
                      }
                      break;
                    case "D":
                      // - Giao dịch đi (-)
                      color = AppColor.RED_TEXT;
                      break;
                  }
                  return MapEntry(
                    index,
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TransactionDetailScreen(
                                  bankDto: widget.dto,
                                  id: transaction.transactionId,
                                ),
                                settings: const RouteSettings(
                                  name: Routes.TRANSACTION_DETAIL_VIEW,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${transaction.transType == 'D' ? '-' : '+'} ${transaction.amount}',
                                  style: TextStyle(color: color, fontSize: 12),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              transaction.time * 1000)),
                                      style: const TextStyle(
                                          color: AppColor.BLACK, fontSize: 12),
                                    ),
                                    Text(
                                      DateFormat('HH:mm').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              transaction.time * 1000)),
                                      style: const TextStyle(
                                          color: AppColor.BLACK, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        if ((index + 1) != widget.listTrans.length)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: MySeparator(
                              color: AppColor.GREY_DADADA,
                            ),
                          )
                      ],
                    ),
                  );
                },
              ).values,
              const SizedBox(height: 10),
            ],
          ),
        ),
        // if (!widget.isHome) ...[
        //   const SizedBox(height: 20),
        //   VietQRButton.solid(
        //       height: 30,
        //       width: 100,
        //       padding: EdgeInsets.zero,
        //       borderRadius: 50,
        //       onPressed: widget.onTap,
        //       isDisabled: false,
        //       child: const Center(
        //         child: Text(
        //           'Xem thêm',
        //           style: TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
        //         ),
        //       )),
        // ]
      ],
    );
  }
}
