import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

import '../../../commons/constants/configurations/app_images.dart';
import '../../../commons/constants/configurations/route.dart';
import '../../../commons/utils/currency_utils.dart';

class PopupInvoiceSuccess extends StatelessWidget {
  final bool isInvoiceDetail;
  final String billNumber;
  final String totalAmount;
  final String timePaid;

  const PopupInvoiceSuccess(
      {super.key,
      required this.billNumber,
      required this.isInvoiceDetail,
      required this.totalAmount,
      required this.timePaid});

  @override
  Widget build(BuildContext context) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timePaid) * 1000);
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(date);
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 30),
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
      height: MediaQuery.of(context).size.height * 0.6,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset(AppImages.icSuccessInGreen, height: 200),
              DefaultTextStyle(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                ),
                child: Text(
                  'Thanh toán hoá đơn',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    child: Text(
                      billNumber,
                    ),
                  ),
                  DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                    ),
                    child: Text(
                      ' thành công!',
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                    ),
                    child: Text(
                      'Số tiền',
                    ),
                  ),
                  DefaultTextStyle(
                    style: TextStyle(
                      color: AppColor.GREEN,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    child: Text(
                      ' ${CurrencyUtils.instance.getCurrencyFormatted(totalAmount)} VND',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              DefaultTextStyle(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
                child: Text(
                  'Thời gian TT: ${formattedDate}',
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                if (isInvoiceDetail == true) {
                  Navigator.pushReplacementNamed(context, Routes.DASHBOARD);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                height: 50,
                // alignment: Alignment.bottomCenter,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.BLUE_TEXT,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: DefaultTextStyle(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.WHITE,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                    child: Text(
                      'Hoàn thành',
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
