import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/numeral.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/models/bank_account_dto.dart';

class BankCardWidget extends StatelessWidget {
  final BankAccountDTO dto;
  final double width;
  final bool? isEnableColorBg;
  final Color? colorBg;

  const BankCardWidget({
    super.key,
    required this.dto,
    required this.width,
    this.isEnableColorBg,
    this.colorBg,
  });

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        width: width,
        height: width / Numeral.BANK_CARD_RATIO,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: DefaultTheme.GREY_TOP_TAB_BAR,
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(2, 2),
            ),
          ],
          image: (isEnableColorBg != null && isEnableColorBg!)
              ? null
              : DecorationImage(
                  image: AssetImage(
                    (dto.type == Stringify.CARD_TYPE_BUSINESS)
                        ? 'assets/images/bg-admin-card.png'
                        : 'assets/images/bg-member-card.png',
                  ),
                ),
          color: (isEnableColorBg != null && isEnableColorBg!)
              ? colorBg
              : DefaultTheme.WHITE,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Container(
                    width: width / 8,
                    height: width / 8,
                    decoration: BoxDecoration(
                      color: DefaultTheme.WHITE,
                      image: DecorationImage(
                        image: ImageUtils.instance.getImageNetWork(dto.imgId),
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Text(
                  dto.bankCode,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: DefaultTheme.GREY_TEXT,
                  ),
                )
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dto.bankAccount,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                          color: DefaultTheme.BLACK,
                        ),
                      ),
                      Text(
                        dto.userBankName.toUpperCase(),
                        style: const TextStyle(
                          color: DefaultTheme.GREY_TEXT,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/ic-viet-qr-org.png',
                  width: 50,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
