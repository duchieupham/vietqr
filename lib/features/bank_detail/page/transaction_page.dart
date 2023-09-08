import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';

class Transaction extends StatelessWidget {
  final BankCardBloc bloc;
  final RefreshCallback refresh;
  final AccountBankDetailDTO dto;
  final String bankId;

  const Transaction(
      {Key? key,
      required this.bloc,
      required this.refresh,
      required this.dto,
      required this.bankId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildRelatedTransaction(context, dto.transactions, bankId);
  }

  Widget _buildRelatedTransaction(
      BuildContext context, List<Transactions> transactions, String bankId) {
    final double width = MediaQuery.of(context).size.width;
    if (transactions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 36),
          child: Text('Chưa có giao dịch nào'),
        ),
      );
    }
    return Column(
      children: [
        Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.TRANSACTION_HISTORY_VIEW,
                    arguments: {'bankId': bankId},
                  );
                },
                child: const Text(
                  'Tất cả',
                  style: TextStyle(
                      color: AppColor.BLUE_TEXT,
                      decoration: TextDecoration.underline),
                ))),
        Expanded(
          child: RefreshIndicator(
            onRefresh: refresh,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.TRANSACTION_DETAIL,
                      arguments: {
                        'transactionId': transactions[index].transactionId,
                        'bankCardBloc': bloc,
                        'bankId': bankId,
                      },
                    );
                  },
                  child: Container(
                    width: width,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: Icon(
                            TransactionUtils.instance.getIconStatus(
                              transactions[index].status,
                              transactions[index].transType,
                            ),
                            color: TransactionUtils.instance.getColorStatus(
                              transactions[index].status,
                              transactions[index].type,
                              transactions[index].transType,
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 5)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${TransactionUtils.instance.getTransType(transactions[index].transType)} ${CurrencyUtils.instance.getCurrencyFormatted(transactions[index].amount)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      TransactionUtils.instance.getColorStatus(
                                    transactions[index].status,
                                    transactions[index].type,
                                    transactions[index].transType,
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 3)),
                              Text(
                                transactions[index].content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColor.GREY_TEXT,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          TimeUtils.instance.formatDateFromInt(
                              transactions[index].time, true),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return DividerWidget(width: width);
              },
            ),
          ),
        ),
      ],
    );
  }
}
