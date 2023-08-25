import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/models/top_up_sucsess_dto.dart';

import '../../../commons/utils/time_utils.dart';
import '../../../commons/widgets/divider_widget.dart';

class PopupTopUpSuccess extends StatelessWidget {
  final TopUpSuccessDTO dto;

  const PopupTopUpSuccess({Key? key, required this.dto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            const SizedBox(
              width: 32,
            ),
            Text(
              dto.paymentType == '0' ? 'Dịch vụ VietQR' : 'Nạp tiền điện thoại',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.clear,
                size: 18,
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Align(
          alignment: Alignment.center,
          child: Text(
            '+ ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)} ${dto.paymentType == '0' ? 'VQR' : 'VND'}',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: AppColor.BLUE_TEXT,
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            'Nạp tiền thành công',
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 44)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Dịch vụ',
            ),
            const Spacer(),
            Text(
              dto.paymentType == '0'
                  ? 'Nạp tiền dịch vụ VietQR'
                  : 'Nạp tiền điện thoại',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: DividerWidget(
            width: width,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dto.paymentType == '0'
                  ? 'Nạp tiền cho tài khoản'
                  : 'Nạp tiền cho số điện thoại',
            ),
            const Spacer(),
            Text(
              dto.phoneNo,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: DividerWidget(
            width: width,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Mã giao dịch',
            ),
            const Spacer(),
            Text(
              dto.billNumber,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: DividerWidget(
            width: width,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Thời gian:',
            ),
            const Spacer(),
            Text(
              TimeUtils.instance.formatTimeDateFromInt(int.parse(dto.time)),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Spacer(),
        MButtonWidget(
            title: 'Đóng',
            colorEnableText: AppColor.WHITE,
            colorEnableBgr: AppColor.BLUE_TEXT,
            margin: EdgeInsets.zero,
            isEnable: true,
            onTap: () {
              eventBus.fire(ReloadWallet());
              Navigator.of(context).pop();
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            })
      ],
    );
  }
}
