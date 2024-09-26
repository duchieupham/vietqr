import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/providers/qr_box_provider.dart';

class ItemBankWidget extends StatelessWidget {
  final int index;
  final Function(BankAccountDTO) onSelect;
  final BankAccountDTO dto;
  const ItemBankWidget(
      {super.key,
      required this.dto,
      required this.onSelect,
      required this.index});

  @override
  Widget build(BuildContext context) {
    bool isSelect = false;
    return Consumer<QRBoxProvider>(
      builder: (context, value, child) {
        isSelect = value.selectBank == value.listAuthBank[index];
        return InkWell(
          onTap: () {
            onSelect(dto);
          },
          child: Container(
            color:
                isSelect ? AppColor.BLUE_TEXT.withOpacity(0.3) : AppColor.WHITE,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Row(
              children: [
                Container(
                  width: 75,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 0.5, color: Colors.grey),
                    image: DecorationImage(
                      image: ImageUtils.instance.getImageNetWork(dto.imgId),
                    ),
                  ),
                  // Placeholder for bank logo
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 175,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dto.bankAccount,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      Text(
                        dto.userBankName,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
