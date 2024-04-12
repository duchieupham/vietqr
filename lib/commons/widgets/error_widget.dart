import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/widgets/pin_widget.dart';
import 'package:vierqr/services/providers/maintain_charge_provider.dart';

import '../../services/providers/pin_provider.dart';
import '../constants/configurations/numeral.dart';
import '../constants/configurations/theme.dart';

class ErrorDialogWidget extends StatelessWidget {
  final String text;
  final Function(String) onDone;
  final Function() onClose;
  final TextEditingController editingController;

  final FocusNode focusNode;
  const ErrorDialogWidget({
    super.key,
    required this.text,
    required this.onDone,
    required this.onClose,
    required this.focusNode,
    required this.editingController,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MaintainChargeProvider>(
      builder: (context, value, child) {
        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Nhập mật khẩu tài khoản \ncủa bạn để xác thực",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: value.isError == true
                              ? AppColor.RED_TEXT
                              : AppColor.BLUE_TEXT,
                          width: 0.5)),
                  child: Center(
                    child: PinWidget(
                      editingController: editingController,
                      width: MediaQuery.of(context).size.width,
                      pinSize: 15,
                      pinLength: Numeral.DEFAULT_PIN_LENGTH,
                      focusNode: focusNode,
                      onDone: onDone,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                value.isError == true
                    ? Center(
                        child: Text(
                          text,
                          style:
                              TextStyle(fontSize: 13, color: AppColor.RED_TEXT),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: onClose,
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
