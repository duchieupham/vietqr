import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class PolicyViewWidget extends StatefulWidget {
  final GestureTapCallback? onTap;
  final ValueChanged<bool?>? onSelectPolicy;
  final bool? isAgreeWithPolicy;
  final String bankAccount;
  final String bankCode;

  const PolicyViewWidget({
    super.key,
    this.onTap,
    this.onSelectPolicy,
    this.isAgreeWithPolicy = false,
    required this.bankAccount,
    required this.bankCode,
  });

  @override
  State<PolicyViewWidget> createState() => _PolicyViewWidgetState();
}

class _PolicyViewWidgetState extends State<PolicyViewWidget> {
  bool isAgreeWithPolicy = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Điều khoản sử dụng dịch vụ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            constraints: const BoxConstraints(
              maxHeight: 40,
              minHeight: 40,
              maxWidth: 250,
            ),
            decoration: BoxDecoration(
              gradient: VietQRTheme.gradientColor.lilyLinear,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: ShaderMask(
                shaderCallback: (bounds) => VietQRTheme
                    .gradientColor.brightBlueLinear
                    .createShader(bounds),
                child: Text(
                  widget.bankCode == 'MB'
                      ? '01/2023/HDDV/MB-BLUECOM'
                      : 'BIDV VietQR',
                  style: const TextStyle(
                      color: AppColor.WHITE,
                      fontWeight: FontWeight.normal,
                      fontSize: 15),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.BLUE_BGR),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: (widget.bankCode == 'MB')
                ? RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColor.BLACK,
                        height: 1.4,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Kính gửi Quý Khách hàng,\n',
                        ),
                        //
                        const TextSpan(
                          text: 'MB Bank và BLUECOM (',
                        ),
                        const TextSpan(
                          text: 'VIETQR.VN',
                          style: TextStyle(
                            fontSize: 15,
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
                          text: 'xin gửi đến Quý khách ',
                        ),
                        //
                        const TextSpan(
                          text:
                              'Điều khoản và Điều kiện sử dụng dịch vụ Nhận Biến Động Số Dư trên tài khoản ngân hàng số “',
                        ),
                        TextSpan(
                          text: widget.bankAccount,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColor.BLACK,
                            height: 1.4,
                          ),
                        ),
                        const TextSpan(
                          text: '” của Quý khách mở tại ngân hàng MB Bank.\n\n',
                        ),
                        const TextSpan(
                          text:
                              'Căn cứ theo hợp đồng hợp tác số\n01/2023/HĐDV/MB-BLUECOM ký ngày 09 tháng 03 năm 2023.\n\n',
                        ),
                        const TextSpan(
                          text: 'Chi tiết tại đường link ',
                        ),
                        TextSpan(
                          text: 'Điều khoản sử dụng dịch vụ.\n\n',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: AppColor.BLUE_TEXT,
                            height: 1.4,
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
                              'Quý khách vui lòng xác nhận Đã đọc, hiểu và đồng ý sử dụng dịch vụ bằng cách nhập mã OTP do ngân hàng TMCP Quân Đội gửi đến số điện thoại của Quý Khách.\n\n',
                        ),
                        const TextSpan(
                          text:
                              'Xin cảm ơn Quý khách đã sử dụng dịch vụ của chúng tôi.',
                        ),
                      ],
                    ),
                  )
                : RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColor.BLACK,
                        height: 1.4,
                      ),
                      children: [
                        const TextSpan(text: 'Tôi đã đọc và đồng ý để'),
                        const TextSpan(
                            text: ' BIDV ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const TextSpan(
                          text:
                              'cung cấp thông tin báo “Có” giao dịch trên Tài khoản Định danh của tôi cho',
                        ),
                        const TextSpan(
                            text: ' Công ty cổ phần Bluecom Việt Nam ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const TextSpan(
                          text:
                              'và đồng ý với điều kiện và điều khoản sử dụng Dịch vụ.\n\n',
                        ),
                        const TextSpan(
                          text: 'Chi tiết tại đường link ',
                        ),
                        TextSpan(
                          text: 'Điều khoản sử dụng dịch vụ.\n\n',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: AppColor.BLUE_TEXT,
                            height: 1.4,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              // ignore: deprecated_member_use
                              await launch(
                                'https://bidv.com.vn/uudai/DKDKDV_VIETQR_BLUECOM_160524.pdf',
                                forceSafariVC: false,
                              );
                            },
                        ),
                      ],
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
