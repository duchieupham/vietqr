import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';

class SavePhoneBookScreen extends StatelessWidget {
  const SavePhoneBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MAppBar(
        title: 'Lưu danh bạ',
        actions: [
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              child: Image.asset(
                'assets/images/ic-edit.png',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: QrImage(
                data: '',
                version: QrVersions.auto,
                embeddedImage:
                    const AssetImage('assets/images/ic-viet-qr-small.png'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: const Size(30, 30),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Loại QR',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColor.WHITE,
                  ),
                  child: const Text(
                    'VietQR ID',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            TextFieldCustom(
              isObscureText: false,
              maxLines: 1,
              fillColor: AppColor.WHITE,
              // controller: provider.contentController,
              title: 'Biệt danh',
              textFieldType: TextfieldType.LABEL,
              hintText: 'Tìm kiếm danh bạ',
              inputType: TextInputType.text,
              keyboardAction: TextInputAction.next,
              onChange: (value) {},
            ),
            const SizedBox(height: 30),
            TextFieldCustom(
              isObscureText: false,
              maxLines: 1,
              fillColor: AppColor.WHITE,
              // controller: provider.contentController,
              title: 'Ghi chú',
              textFieldType: TextfieldType.LABEL,
              hintText: 'Đoạn ghi chú cho thông tin danh bạ',
              inputType: TextInputType.text,
              keyboardAction: TextInputAction.next,
              onChange: (value) {},
            ),
          ],
        ),
      ),
      bottomSheet: MButtonWidget(
        title: 'Lưu danh bạ',
        onTap: () {},
      ),
    );
  }
}
