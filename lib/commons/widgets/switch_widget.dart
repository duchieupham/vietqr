import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class SwitchVietQRWidget extends StatelessWidget {
  const SwitchVietQRWidget({required this.value, required this.onChanged, super.key});

  final bool value;
  final Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
        value: value,
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColor.BLUE_TEXT.withOpacity(0.3);
          }
          return AppColor.GREY_DADADA.withOpacity(0.3);
        }),
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColor.BLUE_TEXT;
          }
          return AppColor.GREY_DADADA;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (final Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return null;
            }

            return AppColor.TRANSPARENT;
          },
        ),
        onChanged: onChanged);
  }
}
