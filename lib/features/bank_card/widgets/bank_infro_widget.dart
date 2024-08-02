import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/helper/dialog_helper.dart';
import 'package:vierqr/commons/utils/format_date.dart';
import 'package:vierqr/features/bank_detail_new/bank_card_detail_new_screen.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/providers/maintain_charge_provider.dart';

class BankInfroWidget extends StatefulWidget {
  final BankAccountDTO dto;
  const BankInfroWidget({super.key, required this.dto});

  @override
  State<BankInfroWidget> createState() => _BankInfroWidgetState();
}

class _BankInfroWidgetState extends State<BankInfroWidget> with DialogHelper {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
          color: AppColor.WHITE,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColor.BLACK.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            )
          ]),
      child: Row(
        children: [
          XImage(
            imagePath: widget.dto.isAuthenticated
                ? widget.dto.mmsActive
                    ? 'assets/images/ic-diamond-pro.png'
                    : 'assets/images/ic-diamond.png'
                : 'assets/images/linked-logo.png',
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 6),
          if (widget.dto.isAuthenticated) ...[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => widget.dto.mmsActive
                        ? VietQRTheme.gradientColor.vietQrPro
                            .createShader(bounds)
                        : VietQRTheme.gradientColor.brightBlueLinear
                            .createShader(bounds),
                    child: const Text(
                      'VietQR Plus',
                      style: TextStyle(fontSize: 14, color: AppColor.WHITE),
                    ),
                  ),
                  if (widget.dto.validFeeTo! != 0 &&
                      inclusiveDays(widget.dto.validFeeTo!) <= 7)
                    Text(
                      "Đến ${timestampToDate(widget.dto.validFeeTo!)}",
                      style: const TextStyle(
                          fontSize: 12, color: AppColor.RED_TEXT),
                    )
                ],
              ),
            ),
            if (inclusiveDays(widget.dto.validFeeTo!) > 7)
              Text(
                'Kích hoạt đến ${timestampToDate(widget.dto.validFeeTo!)}',
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              )
            else
              VietQRButton.solid(
                  borderRadius: 40,
                  height: 30,
                  padding: const EdgeInsets.fromLTRB(8, 0, 10, 0),
                  onPressed: () {
                    Provider.of<MaintainChargeProvider>(context, listen: false)
                        .selectedBank(
                            widget.dto.bankAccount, widget.dto.bankShortName);
                    showDialogActiveKey(
                      context,
                      bankId: widget.dto.id,
                      bankCode: widget.dto.bankCode,
                      bankName: widget.dto.bankName,
                      bankAccount: widget.dto.bankAccount,
                      userBankName: widget.dto.userBankName,
                    );
                  },
                  isDisabled: false,
                  child: const Row(
                    children: [
                      XImage(
                        imagePath: 'assets/images/ic-time-black.png',
                        width: 20,
                        height: 20,
                      ),
                      Text(
                        'Gia hạn dịch vụ',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  )),
          ] else
            Expanded(
                child: ShaderMask(
              shaderCallback: (bounds) => VietQRTheme
                  .gradientColor.brightBlueLinear
                  .createShader(bounds),
              child: const Text(
                'Liên kết tài khoản ngân hàng ngay!',
                style: TextStyle(
                    fontSize: 12,
                    color: AppColor.WHITE,
                    fontWeight: FontWeight.bold),
              ),
            )),
          const SizedBox(width: 6),
          VietQRButton.solid(
            width: 30,
            height: 30,
            borderRadius: 100,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BankCardDetailNewScreen(
                      page: 0, dto: widget.dto, bankId: widget.dto.id),
                  settings: const RouteSettings(
                    name: Routes.BANK_CARD_DETAIL_NEW,
                  ),
                ),
              );
            },
            isDisabled: false,
            padding: EdgeInsets.zero,
            child: const Center(
              child: XImage(
                imagePath: 'assets/images/ic-i-black.png',
                width: 20,
                height: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
