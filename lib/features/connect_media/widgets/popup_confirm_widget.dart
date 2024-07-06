import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class PopUpConfirm extends StatefulWidget {
  const PopUpConfirm({super.key});

  @override
  State<PopUpConfirm> createState() => _PopUpConfirmState();
}

class _PopUpConfirmState extends State<PopUpConfirm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.6,
      height: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Giao dịch có đối soát',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.clear,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text.rich(
            TextSpan(
              text:
                  'Giao dịch có đối soát là một loại giao dịch được tạo từ hệ thống ',
              style: TextStyle(fontSize: 13),
              children: [
                TextSpan(
                  text: 'VietQR.VN',
                  style: TextStyle(
                      color: AppColor.BLUE_TEXT,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColor.BLUE_TEXT),
                ),
                TextSpan(
                  text:
                      '. Thông tin giao dịch này bao gồm các chi tiết như thông tin ',
                ),
                TextSpan(
                  text: 'tài khoản ngân hàng, số tiền',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' và ',
                ),
                TextSpan(
                  text: 'nội dung chuyển khoản',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '. Điều đặc biệt ở giao dịch có đối soát là thông tin ',
                ),
                TextSpan(
                  text:
                      'được đối soát, kiểm tra dựa trên các mã như mã đơn hàng hoặc mã điểm bán',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      '. Việc đối soát này giúp đảm bảo tính chính xác và an toàn của giao dịch, tránh được các rủi ro như nhầm lẫn thông tin hay gian lận.\n\n'
                      'Giao dịch có đối soát mang lại nhiều lợi ích cho cả người mua và người bán, như tăng độ tin cậy, giảm thiểu rủi ro và đảm bảo tính minh bạch của giao dịch. Đây là một tính năng quan trọng của hệ thống VietQR.VN, góp phần nâng cao trải nghiệm thanh toán và mua bán trực tuyến.',
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  Color(0xFFE1EFFF),
                  Color(0xFFE5F9FF),
                ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Center(
                  child: Text(
                'Tôi đã hiểu',
                style: TextStyle(fontSize: 13, color: AppColor.BLUE_TEXT),
              )),
            ),
          )
        ],
      ),
    );
  }
}
