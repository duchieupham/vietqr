import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/key_free_dto.dart';

class PopUpKeyFree extends StatefulWidget {
  BankAccountDTO? dto;
  KeyFreeDTO keyDTO;
  PopUpKeyFree({super.key, required this.dto, required this.keyDTO});

  @override
  State<PopUpKeyFree> createState() => _PopUpKeyFreeState();
}

class _PopUpKeyFreeState extends State<PopUpKeyFree> {
  String formatKey(String key) {
    return key
        .replaceAllMapped(RegExp(r".{1,4}"), (match) => "${match.group(0)} - ")
        .replaceAll(RegExp(r" - $"), '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
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
                'Mã kích hoạt dịch vụ VietQR',
                style: TextStyle(fontSize: 18),
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
          const Text('miễn phí 01 tháng cho tài khoản',
              style: TextStyle(fontSize: 18)),
          Text(
            '${widget.dto!.bankShortName} - ${widget.dto!.bankAccount}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          widget.keyDTO.status == 0
              ? Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColor.GREEN,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Mã kích hoạt khả dụng',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.GREEN,
                      ),
                    )
                  ],
                )
              : Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColor.GREY_TEXT,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Mã kích hoạt đã sử dụng',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.GREY_TEXT,
                      ),
                    )
                  ],
                ),
          const SizedBox(height: 20),
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(colors: [
                Color(0xFFD8ECF8),
                Color(0xFFFFEAD9),
                Color(0xFFF5C9D1),
              ], begin: Alignment.centerLeft, end: Alignment.centerRight),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      height: 30,
                      width: 30,
                      color: AppColor.TRANSPARENT,
                    ),
                  ),
                  Text(
                    // ' ${widget.keyDTO.keyActive}',
                    formatKey(widget.keyDTO.keyActive),
                    style: const TextStyle(fontSize: 15),
                  ),
                  InkWell(
                    onTap: () {
                      FlutterClipboard.copy(widget.keyDTO.keyActive).then(
                        (value) => Fluttertoast.showToast(
                          msg: 'Đã sao chép',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).hintColor,
                          fontSize: 15,
                          webBgColor: 'rgba(255, 255, 255, 0.5)',
                          webPosition: 'center',
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColor.GREY_F0F4FA,
                        ),
                        child: const XImage(
                          imagePath: 'assets/images/ic-save-blue.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF00C6FF),
                      Color(0xFF0072FF),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: Text(
                    'Hoàn tất',
                    style: TextStyle(
                      fontSize: 18,
                      // decoration: TextDecoration.underline,
                      // decorationColor: Colors.transparent,
                      // decorationThickness: 2,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [
                            Color(0xFF00C6FF),
                            Color(0xFF0072FF),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(const Rect.fromLTWH(0, 0, 200, 30)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
