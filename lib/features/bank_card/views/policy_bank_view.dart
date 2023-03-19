import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/web_view/views/custom_web_view.dart';
import 'package:vierqr/services/providers/add_bank_provider.dart';

class PolicyBankView extends StatelessWidget {
  final TextEditingController bankAccountController;
  final TextEditingController nameController;
  final TextEditingController nationalController;
  final TextEditingController phoneAuthenController;
  static late BankCardBloc bankCardBloc;

  const PolicyBankView({
    super.key,
    required this.bankAccountController,
    required this.nameController,
    required this.nationalController,
    required this.phoneAuthenController,
  });

  void initialServices(BuildContext context) {
    bankCardBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    initialServices(context);
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Container(
                width: width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 16,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: 'Kính gửi Quý Khách hàng,\n'),
                      const TextSpan(text: 'MBBank và Bluecom ('),
                      TextSpan(
                        text: 'vietqr.vn',
                        style: const TextStyle(
                          color: DefaultTheme.GREEN,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            await DialogWidget.instance.showModalBottomContent(
                              context: context,
                              height: height * 0.8,
                              widget: CustomWebView(
                                url: 'https://vietqr.vn',
                                title: 'Điều khoản dịch vụ',
                                height: height * 0.8,
                              ),
                            );
                          },
                      ),
                      const TextSpan(
                          text:
                              ') xin gửi đến Quý Khách Điều khoản và điều kiện sử dụng dịch vụ nhận biến động số dư trên tài khoản số "'),
                      TextSpan(
                        text:
                            Provider.of<AddBankProvider>(context, listen: false)
                                .bankAccount,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                          text:
                              '" của Quý khách mở tại ngân hàng MBBank. Căn cứ theo Hợp đồng Hợp tác số 01/2023/HĐDV/MB-BLUECOM ký ngày 09 tháng 03 năm 2023. Chi tiết tại đường link: '),
                      TextSpan(
                        text: 'https://vietqr.vn/mbbank-dkdv/',
                        style: const TextStyle(
                          color: DefaultTheme.GREEN,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            await DialogWidget.instance.showModalBottomContent(
                              context: context,
                              height: height * 0.8,
                              widget: CustomWebView(
                                url: 'https://vietqr.vn/mbbank-dkdv/',
                                title: 'Điều khoản dịch vụ',
                                height: height * 0.8,
                              ),
                            );
                          },
                      ),
                      const TextSpan(
                          text:
                              '\n\nQuý Khách vui lòng xác nhận đã đọc, hiểu và đồng ý sử dụng dịch vụ bằng cách nhập mã OTP do ngân hàng TMCP Quân đội gửi đến số điện thoại của Quý khách. Xin cảm ơn Quý Khách đã sử dụng dịch vụ của chúng tôi.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(left: 20)),
              SizedBox(
                width: 30,
                height: 30,
                child: Consumer<AddBankProvider>(
                  builder: (context, provider, child) {
                    return Checkbox(
                      activeColor: DefaultTheme.GREEN,
                      value: provider.isAgreeWithPolicy,
                      shape: const CircleBorder(),
                      onChanged: (bool? value) {
                        provider.updateAgreeWithPolicy(value!);
                      },
                    );
                  },
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              const Text(
                'Tôi đã đọc và đồng ý với các điều khoản',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Consumer<AddBankProvider>(
          builder: (context, provider, child) {
            return ButtonWidget(
              width: width - 40,
              text: 'Xác thực',
              textColor: DefaultTheme.WHITE,
              bgColor: (provider.isAgreeWithPolicy)
                  ? DefaultTheme.GREEN
                  : DefaultTheme.GREY_TOP_TAB_BAR,
              function: () async {
                if (provider.isAgreeWithPolicy) {}
              },
            );
          },
        ),
      ],
    );
  }
}
