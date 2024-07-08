import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class DeleteDialogWidget extends StatefulWidget {
  const DeleteDialogWidget({super.key});

  @override
  State<DeleteDialogWidget> createState() => _DeleteDialogWidgetState();
}

class _DeleteDialogWidgetState extends State<DeleteDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: AppColor.BLUE_TEXT.withOpacity(0.2),
                  gradient: const LinearGradient(
                      colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight)),
              child: const XImage(
                imagePath: 'assets/images/ic-remove-black.png',
                width: 80,
                height: 80,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Xoá thư mục QR',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'Ngưng chia sẻ các thẻ QR trong\nthư mục này.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 45),
            InkWell(
              onTap: () {},
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF00C6FF),
                      Color(0xFF0072FF),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  color: const Color(0xFFF0F4FA),
                ),
                child: const Center(
                  child: Text(
                    'Xoá thư mục nhưng không xoá thẻ QR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: AppColor.WHITE),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  color: const Color(0xFFF0F4FA),
                ),
                child: const Center(
                  child: Text(
                    'Xoá thư mục và thẻ QR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: AppColor.BLUE_TEXT),
                  ),
                ),
              ),
            )
          ],
        ),
        Positioned(
            top: 20,
            right: 20,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.close,
                size: 22,
                color: AppColor.GREY_TEXT,
              ),
            ))
      ],
    );
  }
}
