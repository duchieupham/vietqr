import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/commons/utils/logo_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/transaction_dto.dart';

class SMSListItem extends StatelessWidget {
  final TransactionDTO transactionDTO;

  const SMSListItem({
    Key? key,
    required this.transactionDTO,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return BoxLayout(
      width: width,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      enableShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColor.WHITE,
                    image: DecorationImage(
                      image: AssetImage(
                        LogoUtils.instance
                            .getAssetImageBank(transactionDTO.address),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).hintColor,
                      ),
                      children: [
                        TextSpan(
                          text: '${transactionDTO.address}\n',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        (transactionDTO.timeInserted != null)
                            ? TextSpan(
                                text: 'TK: ${transactionDTO.bankAccount}',
                                style: const TextStyle(
                                  color: AppColor.GREY_TEXT,
                                  fontSize: 12,
                                  letterSpacing: 0.2,
                                ),
                              )
                            : const TextSpan(text: ''),
                      ],
                    ),
                  ),
                ),
                Text(
                  TimeUtils.instance.formatDateFromTimeStamp2(
                      transactionDTO.timeInserted, false),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Text(
                        transactionDTO.transaction,
                        style: TextStyle(
                          color: (BankInformationUtil.instance
                                  .isIncome(transactionDTO.transaction))
                              ? AppColor.GREEN
                              : AppColor.RED_TEXT,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, top: 5),
                      child: Text(
                        'Số dư: ${transactionDTO.accountBalance}',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.navigate_next_rounded,
                    color: AppColor.GREY_TEXT,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
