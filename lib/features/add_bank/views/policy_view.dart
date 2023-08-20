import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/layouts/button_widget.dart';

class PolicyView extends StatefulWidget {
  final GestureTapCallback? onTap;
  final ValueChanged<bool?>? onSelectPolicy;
  final bool? isAgreeWithPolicy;

  const PolicyView({
    super.key,
    this.onTap,
    this.onSelectPolicy,
    this.isAgreeWithPolicy = false,
  });

  @override
  State<PolicyView> createState() => _PolicyViewState();
}

class _PolicyViewState extends State<PolicyView> {
  bool isAgreeWithPolicy = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width - 10,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(40)),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.clear, color: Colors.transparent),
                    const Expanded(
                      child: DefaultTextStyle(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.BLACK,
                        ),
                        child: Text(
                          'Điều khoản dịch vụ',
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: const Icon(Icons.clear),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                const SizedBox(height: 8),
                DividerWidget(
                  width: MediaQuery.of(context).size.width,
                ),
                const SizedBox(height: 30),
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.BLACK,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Kính gửi Quý Khách hàng\n',
                      ),
                      //
                      const TextSpan(
                        text: 'MB Bank và BLUECOM (',
                      ),
                      const TextSpan(
                        text: 'VietQR VN',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.BLUE_TEXT,
                          height: 1.4,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(
                        text: ') ',
                      ),
                      const TextSpan(
                        text: 'xin gửi đến Quý Khách\n',
                      ),
                      //
                      const TextSpan(
                        text:
                            'Điều khoản và điều kiện sử dụng dịch vụ nhận biến động số dư trên tài khoản số “',
                      ),
                      const TextSpan(
                        text: '1123355589',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColor.BLACK,
                          height: 1.4,
                        ),
                      ),
                      const TextSpan(
                        text: '” của Quý Khách mở tại ngân hàng MB Bank.\n',
                      ),
                      const TextSpan(
                        text:
                            'Căn cứ theo hợp đồng Hợp tác số 01/2023/HĐDV/MB-BLUECOM ký ngày 09 tháng 03 năm 2023.\n',
                      ),
                      const TextSpan(
                        text: 'Chi tiết tại đường link: ',
                      ),
                      TextSpan(
                        text: 'https://vietqr.vn/mbbank-dkdv\n\n',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.BLUE_TEXT,
                          height: 1.4,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            // ignore: deprecated_member_use
                            await launch(
                              'https://vietqr.vn/mbbank-dkdv',
                              forceSafariVC: false,
                            );
                          },
                      ),
                      const TextSpan(
                        text:
                            'Quý Khách vui lòng xác nhận đã đọc, hiểu và đồng ý sử dụng dịch vụ bằng cách nhập mã OTP do ngân hàng TMCP Quân Đội gửi đến số điện thoại của Quý Khách.\n\n',
                      ),
                      const TextSpan(
                        text:
                            'Xin cảm ơn Quý khách đã sử dụng dịch vụ của chúng tôi.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Checkbox(
                        checkColor: AppColor.BLUE_TEXT,
                        activeColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        side: MaterialStateBorderSide.resolveWith(
                          (states) => const BorderSide(
                            width: 1.0,
                            color: AppColor.BLUE_TEXT,
                          ),
                        ),
                        value: isAgreeWithPolicy,
                        onChanged: (value) {
                          widget.onSelectPolicy!(value);
                          setState(() {
                            isAgreeWithPolicy = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: const DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.BLACK,
                          ),
                          child: Text(
                            'Tôi đã đọc và đồng ý với các điều khoản',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                MButtonWidget(
                  title: 'Xác nhận',
                  isEnable: true,
                  colorEnableBgr: AppColor.BLUE_TEXT,
                  colorEnableText: AppColor.WHITE,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  onTap: widget.onTap,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
