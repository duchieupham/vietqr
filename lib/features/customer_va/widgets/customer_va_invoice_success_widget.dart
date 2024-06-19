import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/models/customer_va_invoice_success_dto.dart';

class CustomerVaInvoiceSuccessWidget extends StatelessWidget {
  final CustomerVaInvoiceSuccessDTO dto;

  const CustomerVaInvoiceSuccessWidget({required this.dto});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Image.asset(
          'assets/images/ic-success-in-green.png',
          width: 150,
        ),
        Text(
          'Thanh toán hoá đơn\n${dto.billId} thành công!',
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 25,
              color: AppColor.BLACK,
            ),
            children: [
              const TextSpan(
                text: 'Số tiền ',
                style: TextStyle(
                  fontSize: 25,
                  color: AppColor.BLACK,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text:
                    '${CurrencyUtils.instance.getCurrencyFormatted(dto.amount.toString())} VND',
                style: const TextStyle(
                  color: AppColor.GREEN,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text('Thời gian: ${TimeUtils.instance.formatDateFromInt(
          dto.timePaid,
          false,
        )}'),
        const Spacer(),
        ButtonWidget(
          text: 'Hoàn thành',
          borderRadius: 5,
          textColor: AppColor.WHITE,
          bgColor: AppColor.BLUE_TEXT,
          function: () {
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
