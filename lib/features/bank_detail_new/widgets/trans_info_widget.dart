import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class TransInfoWidget extends StatelessWidget {
  const TransInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<TransType> trans = [
      const TransType(
          title: 'Giao dịch chờ thanh toán.', color: AppColor.ORANGE_TRANS),
      const TransType(
          title: 'Giao dịch đến (+) có đối soát.', color: AppColor.GREEN),
      const TransType(
          title: 'Giao dịch đến (+) không đối soát.',
          color: AppColor.BLUE_TEXT),
      const TransType(title: 'Giao dịch đi (-).', color: AppColor.RED_TEXT),
      const TransType(
          title: 'Giao dịch hết hạn thanh toán.', color: AppColor.GREY_TEXT),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text(
                'Phân loại giao dịch',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const XImage(
                  imagePath: 'assets/images/ic-close-black.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),
        ),
        ...trans.map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 20,
                  color: e.color,
                ),
                const SizedBox(width: 20),
                Text(
                  e.title,
                  style: const TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        VietQRButton.solid(
            size: VietQRButtonSize.large,
            onPressed: () {
              Navigator.of(context).pop();
            },
            isDisabled: false,
            child: const Center(
              child: Text(
                'Tôi đã hiểu',
                style: TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
              ),
            ))
      ],
    );
  }
}

class TransType {
  final String title;
  final Color color;

  const TransType({required this.title, required this.color});
}
