import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrencyUtils {
  const CurrencyUtils._privateConsrtructor();

  static const CurrencyUtils _instance = CurrencyUtils._privateConsrtructor();
  static CurrencyUtils get instance => _instance;

  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.tryParse(s) ?? '0');

  String getCurrencyFormatted(String value) {
    String result = '';
    if (value.isNotEmpty) {
      if (value.length > 3) {
        result = _formatNumber(value.replaceAll(',', ''));
      } else {
        result = value;
      }
    } else {
      result = '0';
    }
    return result;
  }

  void formatCurrencyTextController(TextEditingController controller) {
    try {
      if (controller.text.length > 3) {
        controller.value = controller.value
            .copyWith(text: _formatNumber(controller.text.replaceAll(',', '')));
        controller.selection =
            TextSelection.collapsed(offset: controller.text.length);
      }
    } catch (e) {
      controller.text = controller.text;
      controller.selection =
          TextSelection.collapsed(offset: controller.text.length);
    }
  }
}
