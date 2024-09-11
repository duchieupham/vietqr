import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/services/providers/invoice_provider.dart';

class BottomPayment extends StatelessWidget {
  final InvoiceProvider provider;
  final int selectd;
  final int amount;
  const BottomPayment(
      {super.key,
      required this.provider,
      required this.amount,
      required this.selectd});

  @override
  Widget build(BuildContext context) {
    if (provider.selectedStatus == 1) {
      return const SizedBox.shrink();
    }
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Đang chọn: $selectd'),
              const SizedBox(height: 4),
              RichText(
                  text: const TextSpan(
                text: 'Tổng tiền (VND): ',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.BLACK),
              )),
              Text(
                CurrencyUtils.instance.getCurrencyFormatted(amount.toString()),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.ORANGE_DARK),
              )
            ],
          ),
          VietQRButton.gradient(
              borderRadius: 100,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              onPressed: () {},
              isDisabled: amount == 0,
              child: Center(
                  child: Text(
                'Thanh toán hóa đơn',
                style: TextStyle(
                    color: amount == 0 ? AppColor.BLACK : AppColor.WHITE),
              )))
        ],
      ),
    );
  }
}
