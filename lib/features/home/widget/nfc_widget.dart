import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/features/mobile_recharge/mobile_recharge_screen.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';

class NFCWidget extends StatefulWidget {
  @override
  State<NFCWidget> createState() => _NFCWidgetState();
}

class _NFCWidgetState extends State<NFCWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Nạp tiền điện thoại',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColor.textBlack,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              Consumer<AuthProvider>(
                builder: (context, provider, child) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColor.greyF0F0F0,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColor.grey979797,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(text: 'Số dư: '),
                          TextSpan(
                            text:
                                '${CurrencyUtils.instance.getCurrencyFormatted(provider.introduceDTO?.amount ?? '0')}',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColor.BLUE_TEXT,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: ' VQR',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColor.textBlack,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Image.asset(
                'assets/images/logo-mobile-recharge-trans.png',
                width: 100,
                height: 140,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColor.textBlack,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(text: '$textContent\n'),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              MButtonWidget(
                title: 'Nạp tiền điện thoại',
                isEnable: true,
                onTap: () {
                  Navigator.pop(context);
                  NavigatorUtils.navigatePage(context, MobileRechargeScreen(),
                      routeName: MobileRechargeScreen.routeName);
                },
              ),
              MButtonWidget(
                title: 'Đóng',
                isEnable: true,
                colorEnableBgr: AppColor.greyF0F0F0,
                colorEnableText: AppColor.BLACK,
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  String textContent =
      'Dễ dàng nạp tiền điện thoại qua\nứng dụng với phương thức thanh toán VQR.\nBạn có muốn nạp tiền điện thoại không?';
}
