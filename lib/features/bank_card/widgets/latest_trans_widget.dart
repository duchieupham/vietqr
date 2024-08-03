import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/models/nearest_transaction_dto.dart';

class LatestTransWidget extends StatefulWidget {
  const LatestTransWidget({super.key});

  @override
  State<LatestTransWidget> createState() => _LatestTransWidgetState();
}

class _LatestTransWidgetState extends State<LatestTransWidget> {
  final BankBloc bankBloc = getIt.get<BankBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<NearestTransDTO> get list => bankBloc.state.listTrans;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BankBloc, BankState, List<NearestTransDTO>>(
      bloc: bankBloc,
      selector: (state) => state.listTrans,
      builder: (context, state) {
        if (list.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            const SizedBox(height: 20),
            Container(
              height: 320,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
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
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: const MySeparator(
                      color: AppColor.GREY_DADADA,
                    ),
                  ),
                  Expanded(
                      child: ListView.separated(
                          padding: const EdgeInsets.only(top: 0),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final transaction = list[index];
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

                            return Container(
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${transaction.transType == 'D' ? '-' : '+'} ${transaction.amount}',
                                    style:
                                        TextStyle(color: color, fontSize: 12),
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
                            );
                          },
                          separatorBuilder: (context, index) => const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: MySeparator(
                                  color: AppColor.GREY_DADADA,
                                ),
                              ),
                          itemCount: list.length))
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
