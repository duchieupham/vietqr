import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/services/providers/pin_provider.dart';

class PinWidget extends StatelessWidget {
  final double width;
  final double pinSize;
  final int pinLength;
  final FocusNode focusNode;
  final Function(String) onDone;
  final TextEditingController? editingController;

  const PinWidget({
    super.key,
    required this.width,
    required this.pinSize,
    required this.pinLength,
    required this.focusNode,
    required this.onDone,
    this.editingController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: width,
          height: pinSize + 5,
          alignment: Alignment.center,
          child: Consumer<PinProvider>(
            builder: ((context, value, child) {
              return ListView.builder(
                itemCount: pinLength,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: ((context, index) {
                  return UnconstrainedBox(
                    child: Container(
                      width: pinSize,
                      height: pinSize,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(pinSize),
                        color: (value.pinLength < index + 1)
                            ? AppColor.GREY_TOP_TAB_BAR
                            : AppColor.BLUE_TEXT,
                        border: Border.all(
                          width: 2,
                          color: (value.pinLength < index + 1)
                              ? AppColor.GREY_TOP_TAB_BAR
                              : AppColor.BLUE_TEXT,
                        ),
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        ),
        Positioned(
          top: 0,
          child: SizedBox(
            width: width,
            height: pinSize + 5,
            child: TextField(
              controller: editingController,
              focusNode: focusNode,
              obscureText: true,
              maxLength: pinLength,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              showCursor: false,
              decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                counterStyle: TextStyle(
                  height: 0,
                ),
                counterText: '',
                border: InputBorder.none,
              ),
              style: const TextStyle(color: AppColor.TRANSPARENT),
              keyboardType: TextInputType.number,
              onChanged: ((text) {
                Provider.of<PinProvider>(context, listen: false)
                    .updatePinLength(text.length);

                if (text.length == pinLength) {
                  focusNode.unfocus();
                  // Provider.of<PinProvider>(context, listen: false).reset();
                  onDone(text);
                }
              }),
            ),
          ),
        ),
      ],
    );
  }
}
