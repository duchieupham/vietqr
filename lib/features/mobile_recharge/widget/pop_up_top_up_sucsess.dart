import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/models/top_up_sucsess_dto.dart';

import '../../../commons/utils/time_utils.dart';

class PopupTopUpSuccess extends StatelessWidget {
  final TopUpSuccessDTO dto;
  const PopupTopUpSuccess({Key? key, required this.dto}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const Text(
          'Nạp tiền thành công',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Align(
          alignment: Alignment.center,
          child: Text(
            '+ ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)} VND',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: AppColor.BLUE_TEXT,
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 32)),
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Hoá đơn:',
              ),
              const Spacer(),
              Text(
                dto.billNumber,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Thời gian:',
              ),
              const Spacer(),
              Text(
                TimeUtils.instance.formatTimeDateFromInt(int.parse(dto.time)),
              ),
            ],
          ),
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
