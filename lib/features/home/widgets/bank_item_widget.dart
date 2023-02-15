import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/logo_utils.dart';
import 'package:vierqr/models/bank_account_dto.dart';

class BankItemWidget extends StatelessWidget {
  final double width;
  final bool isSelected;
  final bool isExpanded;
  final BankAccountDTO bankAccountDTO;

  const BankItemWidget({
    super.key,
    required this.width,
    required this.isSelected,
    required this.isExpanded,
    required this.bankAccountDTO,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: (isSelected)
            ? Theme.of(context).canvasColor
            : DefaultTheme.TRANSPARENT,
      ),
      child: Row(
        children: [
          Image.asset(
            LogoUtils.instance.getAssetImageBank(bankAccountDTO.bankCode),
            width: 50,
            height: 50,
          ),
          (isExpanded)
              ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bankAccountDTO.bankName.trim(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        bankAccountDTO.bankAccount,
                        style: const TextStyle(
                          fontSize: 12,
                          color: DefaultTheme.GREEN,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
