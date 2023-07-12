import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/layouts/button_widget.dart';

class PolicyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
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
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width - 10,
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(40)),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.clear, color: Colors.transparent),
                      Expanded(
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
                      Icon(Icons.clear)
                    ],
                  ),
                  const SizedBox(height: 8),
                  DividerWidget(
                    width: MediaQuery.of(context).size.width,
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.BLACK,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(
                            text: 'Kính gửi Quý Khách hàng\n',
                          ),
                          //
                          TextSpan(
                            text: 'MB Bank và BLUECOM (',
                          ),
                          TextSpan(
                            text: 'VietQR VN',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColor.BLUE_TEXT,
                              height: 1.4,
                            ),
                          ),
                          TextSpan(
                            text: ') ',
                          ),
                          TextSpan(
                            text: 'xin gửi đến Quý Khách\n',
                          ),
                          //
                          TextSpan(
                            text:
                                'Điều khoản và điều kiện sử dụng dịch vụ nhận biến động số dư trên tài khoản số “',
                          ),
                          TextSpan(
                            text: '1123355589',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColor.BLACK,
                              height: 1.4,
                            ),
                          ),
                          TextSpan(
                            text: '” của Quý Khách mở tại ngân hàng MB Bank.\n',
                          ),
                          TextSpan(
                            text:
                                'Căn cứ theo hợp đồng Hợp tác số 01/2023/HĐDV/MB-BLUECOM ký ngày 09 tháng 03 năm 2023.\n',
                          ),
                          TextSpan(
                            text: 'Chi tiết tại đường link: ',
                          ),
                          TextSpan(
                            text: 'https://vietqr.vn/mbbank-dkdv\n\n',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColor.BLUE_TEXT,
                              height: 1.4,
                            ),
                          ),
                          TextSpan(
                            text:
                                'Quý Khách vui lòng xác nhận đã đọc, hiểu và đồng ý sử dụng dịch vụ bằng cách nhập mã OTP do ngân hàng TMCP Quân Đội gửi đến số điện thoại của Quý Khách.\n\n',
                          ),
                          TextSpan(
                            text:
                                'Xin cảm ơn Quý khách đã sử dụng dịch vụ của chúng tôi.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (value) {},
                      ),
                      const DefaultTextStyle(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.BLACK,
                        ),
                        child: Text(
                          'Tôi đã đọc và đồng ý với các điều khoản',
                        ),
                      ),
                    ],
                  ),
                  MButtonWidget(
                    title: 'Xác nhận',
                    isEnable: true,
                    colorEnableBgr: AppColor.BLUE_TEXT,
                    colorEnableText: AppColor.WHITE,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
