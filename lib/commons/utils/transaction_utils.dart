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

  // status = 0 : chờ thanh toán
  // status = 1 : thành công
  // type: 2 : chuyển tiền từ ngân hàng khác
  // type: 0 : chuyển tiền từ viet qr
  ///
  // status = 2 : đã huỷ
  Color getColorStatus(int status, int type, String transType) {
    Color result = AppColor.TRANSPARENT;
    if (transType.trim() == 'D') {
      result = AppColor.RED_CALENDAR;
    } else {
      if (status == 0) {
        result = AppColor.ORANGE_DARK;
      } else if (status == 1) {
        if (type == 2) {
          result = AppColor.BLUE_TEXT;
        } else if (type == 0 || type == 4 || type == 5) {
          result = AppColor.GREEN;
        }
      } else if (status == 2) {
        result = AppColor.GREY_TEXT;
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
    } else if (status == 3) {
      result = 'Thất bại';
    } else {
      result = 'Đã huỷ';
    }
    return result;
  }

  String getTitleTransWallet(int status) {
    String result = '';
    if (status == 0) {
      result = 'Nạp tiền dịch vụ VietQR';
    } else if (status == 1) {
      result = 'Nạp tiền điện thoại';
    } else if (status == 2) {
      result = 'Nạp tiền dịch vụ BĐSD';
    }
    return result;
  }

  String getPathIconStatusWallet(int paymentType) {
    String result = '';
    if (paymentType == 0) {
      result = 'assets/images/ic-vqr-3D-unit.png';
    } else if (paymentType == 1) {
      result = 'assets/images/logo-mobile-money-3D.png';
    }

    return result;
  }

  Color getColorTransWalletStatus(int status) {
    Color result = AppColor.TRANSPARENT;
    if (status == 1) {
      result = AppColor.BLUE_TEXT;
    } else if (status == 2) {
      result = AppColor.GREY_TEXT;
    } else if (status == 3) {
      result = AppColor.RED_TEXT;
    } else {
      result = AppColor.ORANGE;
    }

    return result;
  }

  String getPaymentMethod(int paymentMethod) {
    String result = '';
    if (paymentMethod == 0) {
      result = 'Thanh toán bằng VQR';
    } else if (paymentMethod == 1) {
      result = 'Thanh toán bằng mã VietQR VN';
    }
    return result;
  }
}
