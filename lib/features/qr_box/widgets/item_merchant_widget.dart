import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/models/store/merchant_dto.dart';

class ItemMerchantWidget extends StatelessWidget {
  final Function(MerchantDTO) onSelect;
  final MerchantDTO dto;
  final bool isSelect;
  const ItemMerchantWidget(
      {super.key,
      required this.onSelect,
      required this.dto,
      required this.isSelect});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSelect(dto);
      },
      child: Container(
        color: isSelect ? AppColor.BLUE_TEXT.withOpacity(0.3) : AppColor.WHITE,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dto.name,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${dto.totalTerminals.toString()} cửa hàng',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
