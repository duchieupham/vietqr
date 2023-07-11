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
      result = 'Đến tài khoản';
    } else {
      result = 'Từ tài khoản';
    }
    return result;
  }

  Color getColorStatus(int status, int type, String transType) {
    Color result = AppColor.TRANSPARENT;
    if (transType.trim() == 'D') {
      result = AppColor.RED_CALENDAR;
    } else {
      if (type == 2) {
        result = AppColor.BLUE_TEXT;
      } else {
        if (status == 0) {
          result = AppColor.ORANGE;
        } else if (status == 1) {
          result = AppColor.GREEN;
        } else {
          result = AppColor.GREY_TEXT;
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

  String getStatusString(int status) {
    String result = '';
    if (status == 0) {
      result = 'Chờ thanh toán';
    } else if (status == 1) {
      result = 'Thành công';
    } else {
      result = 'Đã huỷ';
    }
    return result;
  }
}
