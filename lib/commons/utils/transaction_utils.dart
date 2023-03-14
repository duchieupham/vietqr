import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class TransactionUtils {
  const TransactionUtils._privateConsrtructor();

  static const TransactionUtils _instance =
      TransactionUtils._privateConsrtructor();
  static TransactionUtils get instance => _instance;

  //status = 0 => not paid
  //status = 1 => paid

  Color getColorStatus(int status) {
    Color result = DefaultTheme.TRANSPARENT;
    if (status == 0) {
      result = DefaultTheme.ORANGE;
    } else {
      result = DefaultTheme.GREEN;
    }
    return result;
  }

  IconData? getIconStatus(int status) {
    IconData? result;
    if (status == 0) {
      result = Icons.pending_actions_rounded;
    } else {
      result = Icons.check_circle_outline_rounded;
    }
    return result;
  }
}
