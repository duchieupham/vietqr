import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/checker_provider.dart';

class QRScanWidget extends StatelessWidget {
  static final CheckerProvider checkerProvider = CheckerProvider(false);

  const QRScanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    checkerProvider.updateValue(false);
    final double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(padding: EdgeInsets.only(bottom: 30)),
        SizedBox(
          width: width * 0.4,
          child: Image.asset(
            'assets/images/ic-qr-scanning.png',
          ),
        ),
        const Text(
          'Giới thiệu về quét mã QR',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColor.WHITE,
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        const Text(
          'VietQR cung cấp tính năng quét mã QR trên hệ thống để người dùng có thực hiện các tính năng dễ dàng',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColor.WHITE,
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 30)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '· Sao chép mã VietQR để thêm/liên kết với TK ngân hàng trong hệ thống.',
            style: TextStyle(
              color: AppColor.WHITE,
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '· Quét mã QR Căn Cước Công dân để cập nhật thông tin người dùng.',
            style: TextStyle(
              color: AppColor.WHITE,
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '· Đăng nhập hệ thống trên trình duyệt web bằng việc quét mã QR.',
            style: TextStyle(
              color: AppColor.WHITE,
            ),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: width,
          child: ValueListenableBuilder(
            valueListenable: checkerProvider,
            builder: (_, provider, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Checkbox(
                      activeColor: AppColor.GREEN,
                      value: provider as bool,
                      shape: const CircleBorder(),
                      side: const BorderSide(color: AppColor.WHITE),
                      onChanged: (bool? value) async {
                        checkerProvider.updateValue(value!);
                        await SharePrefUtils.saveQrIntro(value);
                      },
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  const Text(
                    'Bỏ qua thông tin này ở lần tiếp theo',
                    style: TextStyle(
                      color: AppColor.WHITE,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 20)),
        ButtonIconWidget(
          width: width - 40,
          height: 40,
          icon: Icons.qr_code_scanner_rounded,
          title: 'Quét mã QR',
          function: () {
            Navigator.pop(context);
          },
          bgColor: AppColor.BLACK_BUTTON,
          textColor: AppColor.WHITE,
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
        ),
      ],
    );
  }
}
