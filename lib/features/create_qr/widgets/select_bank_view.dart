import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/models/bank_account_dto.dart';

class SelectBankView extends StatelessWidget {
  final BankAccountDTO dto;
  final GestureTapCallback? onTap;
  final bool isDivider;
  final bool isSelect;
  final bool isShowIconDrop;

  const SelectBankView({
    super.key,
    required this.dto,
    this.onTap,
    this.isDivider = false,
    this.isSelect = false,
    this.isShowIconDrop = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: AppColor.WHITE,
            ),
            child: Row(
              children: [
                if (dto.imgId.isNotEmpty)
                  Container(
                    width: 60,
                    height: 30,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ImageUtils.instance.getImageNetWork(dto.imgId),
                      ),
                    ),
                  ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              dto.bankAccount,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.BLACK),
                            ),
                          ),
                          if (isSelect)
                            Icon(Icons.check, color: AppColor.BLUE_TEXT),
                          if (isShowIconDrop)
                            Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: AppColor.BLUE_TEXT,
                            ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      Text(
                        dto.userBankName.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColor.BLACK),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isDivider) const Divider(),
      ],
    );
  }
}
