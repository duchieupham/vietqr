import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class CloseConnectWidget extends StatelessWidget {
  const CloseConnectWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> contentConnectBank = [
      'Chia sẻ Biến động số dư qua các nền tảng mạng xã hội.',
      'Thông báo giọng nói khi thanh toán đơn hàng thành công.',
      'Theo dõi doanh thu cửa hàng trực quan.'
    ];

    final List<String> icContentConnectBank = [
      'assets/images/ic-share-bdsd-black.png',
      'assets/images/ic-voice-black.png',
      'assets/images/ic-monitor-store-black.png',
    ];
    return Container(
      // width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: AppColor.BLUE_BGR),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const XImage(
                imagePath: 'assets/images/ic-suggest.png',
                width: 30,
                height: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => VietQRTheme
                        .gradientColor.aiTextColor
                        .createShader(bounds),
                    child: const Text(
                      'Liên kết tài khoản ngân hàng',
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColor.WHITE,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  const Text(
                    'để nhận biến động số dư và các dịch vụ tích hợp.',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: AppColor.GREY_TEXT,
                        fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: const Divider(color: AppColor.GREY_DADADA),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  XImage(
                    imagePath: icContentConnectBank[index],
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    contentConnectBank[index],
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: AppColor.BLACK,
                        fontSize: 10),
                  ),
                ],
              );
            },
            itemCount: contentConnectBank.length,
          ),
        ],
      ),
    );
  }
}
