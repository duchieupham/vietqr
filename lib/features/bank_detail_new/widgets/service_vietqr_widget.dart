import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/helper/dialog_helper.dart';
import 'package:vierqr/commons/utils/format_date.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/providers/maintain_charge_provider.dart';

class ServiceVietqrWidget extends StatefulWidget {
  final BankAccountDTO bankDTO;
  const ServiceVietqrWidget({super.key, required this.bankDTO});

  @override
  State<ServiceVietqrWidget> createState() => _ServiceVietqrWidgetState();
}

class _ServiceVietqrWidgetState extends State<ServiceVietqrWidget>
    with DialogHelper {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 128,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  XImage(
                    imagePath: widget.bankDTO.mmsActive
                        ? 'assets/images/ic-diamond-pro.png'
                        : 'assets/images/ic-diamond.png',
                    width: 40,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GradientText(
                          'VietQR ${widget.bankDTO.mmsActive ? 'Pro' : 'Plus'} ',
                          style: const TextStyle(fontSize: 12),
                          gradient: widget.bankDTO.mmsActive
                              ? VietQRTheme.gradientColor.vietQrPro
                              : VietQRTheme.gradientColor.brightBlueLinear,
                        ),
                        const SizedBox(height: 4),
                        if (widget.bankDTO.isValidService)
                          if (widget.bankDTO.validFeeTo != 0 &&
                              inclusiveDays(widget.bankDTO.validFeeTo) <= 7 &&
                              inclusiveDays(widget.bankDTO.validFeeTo) > 0)
                            RichText(
                              text: TextSpan(
                                  text: 'Còn ',
                                  style: const TextStyle(
                                      fontSize: 10, color: AppColor.BLACK),
                                  children: [
                                    TextSpan(
                                        text:
                                            '${inclusiveDays(widget.bankDTO.validFeeTo)} ngày',
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: AppColor.RED_TEXT)),
                                    const TextSpan(
                                        text: ' hết hạn',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: AppColor.BLACK)),
                                  ]),
                            )
                          else if (inclusiveDays(widget.bankDTO.validFeeTo) ==
                              0)
                            const Text('Hạn ngày cuối',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 10,
                                ))
                          else if (inclusiveDays(widget.bankDTO.validFeeTo) < 0)
                            Text(
                                'Quá hạn ${inclusiveDays(widget.bankDTO.validFeeTo).abs()} ngày',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 10,
                                ))
                          else
                            Text(
                                'Kích hoạt đến ${timestampToDate(widget.bankDTO.validFeeTo)}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ))
                        else
                          const Text('Chưa kích hoạt'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                Provider.of<MaintainChargeProvider>(context, listen: false)
                    .selectedBank(widget.bankDTO.bankAccount,
                        widget.bankDTO.bankShortName);
                showDialogActiveKey(
                  context,
                  bankId: widget.bankDTO.id,
                  bankCode: widget.bankDTO.bankCode,
                  bankName: widget.bankDTO.bankName,
                  bankAccount: widget.bankDTO.bankAccount,
                  userBankName: widget.bankDTO.userBankName,
                );
              },
              child: Container(
                height: 128,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF6FF),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GradientText(
                          '${widget.bankDTO.isValidService ? 'Gia hạn' : 'Đăng ký'}\ndịch vụ\nVietQR',
                          style: const TextStyle(fontSize: 12),
                          gradient: const LinearGradient(colors: [
                            Color(0xFF00C6FF),
                            Color(0xFF0072FF),
                          ]),
                        ),
                        const XImage(
                          imagePath: 'assets/images/ic-infinity.png',
                          width: 40,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Trải nghiệm các tính năng không giới hạn.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 9,
                      ),
                    ),
                    // Spacer(),
                    const SizedBox(height: 8),
                    const XImage(
                      imagePath: 'assets/images/ic-arrow-boder-blue.png',
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
