import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/transaction_bank_dto.dart';

class TransactionBankItem extends StatelessWidget {
  final TransactionBankDTO transactionDTO;
  const TransactionBankItem({
    super.key,
    required this.transactionDTO,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BoxLayout(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Giao dịch: ',
                            style: TextStyle(
                                fontSize: 12, color: AppColor.GREY_TEXT),
                          ),
                          Text(
                            transactionDTO.amount,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: BankInformationUtil.instance
                                      .isIncome(transactionDTO.amount)
                                  ? AppColor.GREEN
                                  : AppColor.RED_TEXT,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      TimeUtils.instance.formatDateFromTimeStamp2(
                          transactionDTO.transactionDate, true),
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ]),
            ),
            const Padding(padding: EdgeInsets.only(top: 5)),
            // const Text(
            //   'Thời gian',
            //   style: TextStyle(fontSize: 12, color: DefaultTheme.GREY_TEXT),
            // ),
            // Text(
            //   TimeUtils.instance
            //       .formatDateFromTimeStamp2(transactionDTO.timeInserted, false),
            // ),
            const Text(
              'Nội dung',
              style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
            ),
            Text(
              transactionDTO.paymentDetail,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        )
        //  Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text(
        //       TimeUtils.instance
        //           .formatDateFromTimeStamp2(transactionDTO.timeInserted, false),
        //       style: const TextStyle(color: DefaultTheme.GREY_TEXT),
        //     ),
        //     const Padding(padding: EdgeInsets.only(top: 5)),
        //     Container(
        //       padding: const EdgeInsets.all(20),
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(15),
        //         color: (BankInformationUtil.instance
        //                 .isIncome(transactionDTO.transaction))
        //             ? DefaultTheme.GREEN.withOpacity(0.3)
        //             : DefaultTheme.RED_TEXT.withOpacity(0.3),
        //       ),
        //       child: Column(
        //         children: [
        //           SizedBox(
        //             width: width,
        //             child: Text(
        //               transactionDTO.transaction,
        //               style: TextStyle(
        //                 fontSize: 25,
        //                 fontWeight: FontWeight.w600,
        //                 color: BankInformationUtil.instance
        //                         .isIncome(transactionDTO.transaction)
        //                     ? DefaultTheme.GREEN
        //                     : DefaultTheme.RED_TEXT,
        //               ),
        //             ),
        //           ),
        //           const Padding(padding: EdgeInsets.only(top: 5)),
        //           SizedBox(
        //             width: width,
        //             child: Text(
        //               'Tài khoản: ${transactionDTO.bankAccount}',
        //               style: const TextStyle(fontSize: 15),
        //             ),
        //           ),
        //           const Padding(padding: EdgeInsets.only(top: 5)),
        //           SizedBox(
        //             width: width,
        //             child: Text(
        //               'Số dư: ${transactionDTO.accountBalance}',
        //               style: TextStyle(
        //                 fontSize: 15,
        //                 color: BankInformationUtil.instance
        //                         .isIncome(transactionDTO.transaction)
        //                     ? DefaultTheme.GREEN
        //                     : DefaultTheme.RED_TEXT,
        //               ),
        //             ),
        //           ),
        //           const Padding(padding: EdgeInsets.only(top: 5)),
        //           SizedBox(
        //             width: width,
        //             child: Text(
        //               'Nội dung:\n${transactionDTO.content}',
        //               style: const TextStyle(fontSize: 15),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),

        );
  }
}
