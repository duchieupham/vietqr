import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/helper/dialog_helper.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/button_gradient_border_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_account_dto.dart';

class BankInfroV2Widget extends StatefulWidget {
  final BankAccountDTO dto;
  final bool isLoading;
  const BankInfroV2Widget(
      {super.key, required this.dto, required this.isLoading});

  @override
  State<BankInfroV2Widget> createState() => _BankInfroV2WidgetState();
}

class _BankInfroV2WidgetState extends State<BankInfroV2Widget>
    with DialogHelper {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: const Color(
                        0xFFE1EFFF), // Change this to your desired color
                    width: 2.0, // Adjust the border width as needed
                  ),
                ),
                child: Image(
                  image: ImageUtils.instance.getImageNetWork(widget.dto.imgId),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  widget.dto.bankAccount,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  widget.dto.isAuthenticated
                      ? ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF9CD740),
                              Color(0xFF2BACE6),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds),
                          child: const Text(
                            'Đã liên kết',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : const Text(
                          'Liên kết ngay',
                          style: TextStyle(
                            color: AppColor.ORANGE_DARK,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColor.ORANGE_DARK,
                            decorationThickness: 2,
                            fontSize: 12,
                          ),
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColor.BLUE_E1EFFF,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        XImage(
                          imagePath: 'assets/images/ic-i-black.png',
                          width: 20,
                          height: 20,
                        ),
                        Text(
                          'Chi tiết',
                          style: TextStyle(
                            color: AppColor.BLACK,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          GradientBorderButton(
            gradient: VietQRTheme.gradientColor.aiTextColor,
            widget: Container(
              height: 90,
            ),
            borderRadius: BorderRadius.circular(10),
            borderWidth: 1,
          )
        ],
      ),
    );
  }
}
