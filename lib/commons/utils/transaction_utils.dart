import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class TransactionUtils {
  const TransactionUtils._privateConsrtructor();

  static const TransactionUtils _instance =
      TransactionUtils._privateConsrtructor();
  static TransactionUtils get instance => _instance;

  //status = 0 => not paid
  //status = 1 => paid

  String getTransType(String value) {
    String result = '';
    if (value.trim() == 'C') {
      result = '+';
    } else {
      result = '-';
    }
    return result;
  }

  String getPrefixBankAccount(String transType) {
    String result = '';
    if (transType.trim() == 'C') {
      result = 'Đến TK';
    } else {
      result = 'Từ TK';
    }
    return result;
  }

  Color getColorStatus(int status, int type, String transType) {
    Color result = DefaultTheme.TRANSPARENT;
    if (transType.trim() == 'D') {
      result = DefaultTheme.RED_CALENDAR;
    } else {
      if (type == 2) {
        result = DefaultTheme.BLUE_TEXT;
      } else {
        if (status == 0) {
          result = DefaultTheme.ORANGE;
        } else if (status == 1) {
          result = DefaultTheme.GREEN;
        } else {
          result = DefaultTheme.GREY_TEXT;
        }
      }
    }

    return result;
  }

  IconData? getIconStatus(int status, String transType) {
    IconData? result;
    if (transType.trim() == 'D') {
      result = Icons.remove_circle_outline_rounded;
    } else {
      if (status == 0) {
        result = Icons.pending_actions_rounded;
      } else if (status == 1) {
        result = Icons.check_circle_outline_rounded;
      } else {
        result = Icons.cancel_rounded;
      }
    }

    return result;
  }
}
