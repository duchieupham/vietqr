import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/features/customer_va/widgets/customer_va_header_widget.dart';
import 'package:vierqr/services/providers/customer_va/customer_va_insert_provider.dart';

class CustomerVaSuccessView extends StatelessWidget {
  const CustomerVaSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      appBar: CustomerVaHeaderWidget(),
      body: Column(
        children: [
          Expanded(
            child: Consumer<CustomerVaInsertProvider>(
              builder: (context, provider, child) {
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/images/ic-success-in-blue.png',
                        width: 100,
                      ),
                    ),
                    Text(
                      'Đăng ký thu hộ qua\ntài khoản định danh\nthành công!',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          Text('Doanh nghiệp'),
                          const Spacer(),
                          Text(
                            provider.merchantName,
                            style: const TextStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Divider(
                        color: AppColor.GREY_TOP_TAB_BAR,
                        height: 1,
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          Text('Mã doanh nghiệp'),
                          const Spacer(),
                          Text(
                            provider.merchantId,
                            style: const TextStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Divider(
                        color: AppColor.GREY_TOP_TAB_BAR,
                        height: 1,
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          Text('TK ngân hàng'),
                          const Spacer(),
                          Text(
                            'BIDV - ' + provider.bankAccount,
                            style: const TextStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Divider(
                        color: AppColor.GREY_TOP_TAB_BAR,
                        height: 1,
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          Text('CCCD/MST'),
                          const Spacer(),
                          Text(
                            provider.nationalId,
                            style: const TextStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Divider(
                        color: AppColor.GREY_TOP_TAB_BAR,
                        height: 1,
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          Text('SĐT xác thực'),
                          const Spacer(),
                          Text(
                            provider.phoneAuthenticated,
                            style: const TextStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            child: ButtonWidget(
              text: 'Hoàn thành',
              textColor: AppColor.WHITE,
              bgColor: AppColor.BLUE_TEXT,
              borderRadius: 5,
              function: () {
                Provider.of<CustomerVaInsertProvider>(context, listen: false)
                    .doInit();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                if (Navigator.canPop(context)) {
                  Navigator.pop(context, true);
                }

                // Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ),
        ],
      ),
    );
  }
}
