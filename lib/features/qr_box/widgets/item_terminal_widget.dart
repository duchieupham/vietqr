import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/models/terminal_qr_dto.dart';
import 'package:vierqr/services/providers/qr_box_provider.dart';

class ItemTerminalWidget extends StatelessWidget {
  final Function(TerminalQRDTO) onSelect;
  final TerminalQRDTO dto;
  final bool isSelect;
  const ItemTerminalWidget(
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
            Text(dto.terminalName,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(dto.terminalCode,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
