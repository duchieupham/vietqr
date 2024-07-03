import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/features/qr_feed/widgets/custom_textfield.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class VcardWidget extends StatelessWidget {
  final TextEditingController sdtController;
  final TextEditingController contactController;
  final TextEditingController emailController;
  final TextEditingController webController;
  final TextEditingController ctyController;
  final TextEditingController addressController;
  final bool isShow;
  final Function() onToggle;
  final Function(String) onChangePhone;
  final Function(int) onClear;

  const VcardWidget({
    super.key,
    required this.onToggle,
    required this.onClear,
    required this.isShow,
    required this.sdtController,
    required this.contactController,
    required this.emailController,
    required this.webController,
    required this.ctyController,
    required this.addressController,
    required this.onChangePhone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Nhập thông tin\ntạo mã QR VCard',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColor.BLUE_TEXT.withOpacity(0.2),
                    ),
                    child: const XImage(
                        imagePath: 'assets/images/ic-scan-content.png'),
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColor.GREEN.withOpacity(0.2),
                    ),
                    child: const XImage(
                      fit: BoxFit.fitWidth,
                      width: 42,
                      height: 42,
                      imagePath: 'assets/images/ic-img-picker.png',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 30),
        CustomTextField(
          controller: sdtController,
          hintText: 'Nhập số điện thoại',
          labelText: 'Số điện thoại*',
          textInputType: TextInputType.number,
          inputFormatter: [
            FilteringTextInputFormatter.digitsOnly,
            PhoneInputFormatter(
              allowEndlessPhone: false,
              defaultCountryCode: "VN",
            )
          ],
          maxLines: 10,
          borderColor: Colors.grey,
          hintTextColor: Colors.grey,
          onClear: () {
            onClear(1);
          },
          onChanged: (text) {},
        ),
        const SizedBox(height: 30),
        CustomTextField(
          controller: contactController,
          hintText: 'Nhập tên danh bạ',
          labelText: 'Tên danh bạ*',
          borderColor: Colors.grey,
          hintTextColor: Colors.grey,
          onClear: () {
            onClear(2);
          },
          onChanged: (text) {},
        ),
        const SizedBox(height: 30),
        GestureDetector(
          onTap: onToggle,
          child: Container(
            width: 150,
            height: 30,
            decoration: BoxDecoration(
                gradient: VietQRTheme.gradientColor.scan_qr,
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isShow ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColor.BLUE_TEXT,
                  size: 15,
                ),
                const SizedBox(width: 10),
                Text(
                  isShow ? 'Đóng tuỳ chọn' : 'Tuỳ chọn thêm',
                  style: const TextStyle(
                    color: AppColor.BLUE_TEXT,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: isShow,
          child: Column(
            children: [
              const SizedBox(height: 30),
              CustomTextField(
                controller: emailController,
                hintText: 'Nhập thông tin email',
                labelText: 'Email',
                borderColor: Colors.grey,
                hintTextColor: Colors.grey,
                onClear: () {
                  onClear(3);
                },
                onChanged: (text) {
                  // _updateButtonState();
                },
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: webController,
                hintText: 'Nhập thông tin website',
                labelText: 'Website',
                borderColor: Colors.grey,
                hintTextColor: Colors.grey,
                onClear: () {
                  onClear(4);
                },
                onChanged: (text) {
                  // _updateButtonState();
                },
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: ctyController,
                hintText: 'Nhập tên công ty',
                labelText: 'Tên công ty',
                borderColor: Colors.grey,
                hintTextColor: Colors.grey,
                onClear: () {
                  onClear(5);

                  // _controller.clear();
                  // _updateButtonState();
                },
                onChanged: (text) {
                  // _updateButtonState();
                },
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: addressController,
                hintText: 'Nhập thông tin địa chỉ',
                labelText: 'Địa chỉ',
                borderColor: Colors.grey,
                hintTextColor: Colors.grey,
                onClear: () {
                  onClear(6);
                },
                onChanged: (text) {
                  // _updateButtonState();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
