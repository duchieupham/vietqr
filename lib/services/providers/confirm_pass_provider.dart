import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/mobile_recharge/repositories/mobile_recharge_repository.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import '../../navigator/app_navigator.dart';

class ConfirmPassProvider extends ChangeNotifier {
  MobileRechargeRepository mobileRechargeRepository =
      const MobileRechargeRepository();
  bool _errorPass = false;

  bool get errorPass => _errorPass;

  String _pass = '';

  String get pass => _pass;

  bool _completedInput = false;

  bool get completedInput => _completedInput;

  updateErrorPass(bool value) {
    _errorPass = value;

    notifyListeners();
  }

  changePass(String value) {
    _pass = value;
    if (_pass.length == 6) {
      onCompleted(true);
    } else {
      onCompleted(false);
    }
  }

  onCompleted(bool value) {
    _completedInput = value;
    notifyListeners();
  }

  Future requestPayment(String pass,
      {required Function(String) onConfirmSuccess}) async {
    DialogWidget.instance.openLoadingDialog(msg: 'Đang xác thực mật khẩu');
    Map<String, dynamic> data = {};
    String passWord = EncryptUtils.instance.encrypted(
      SharePrefUtils.getPhone(),
      pass,
    );
    data['password'] = passWord;
    data['userId'] = SharePrefUtils.getProfile().userId;
    data['paymentType'] = 1;

    ResponseMessageDTO responseMessageDTO =
        await mobileRechargeRepository.requestPayment(data);

    if (responseMessageDTO.status == 'SUCCESS') {
      Navigator.pop(NavigationService.context!);
      onConfirmSuccess(responseMessageDTO.message);
      updateErrorPass(false);
    }

    _handleError(responseMessageDTO);
  }

  _handleError(ResponseMessageDTO responseMessageDTO) {
    if (responseMessageDTO.status == 'FAILED') {
      Navigator.pop(NavigationService.context!);
      if (responseMessageDTO.message == 'E55') {
        updateErrorPass(true);
      } else {
        DialogWidget.instance.openMsgDialog(
            title: 'Nạp tiền thất bại',
            msg: ErrorUtils.instance
                .getErrorMessage(responseMessageDTO.message));
      }
    }
    if (responseMessageDTO.message == '') {
      Navigator.pop(NavigationService.context!);
      DialogWidget.instance.openMsgDialog(
          title: 'Nạp tiền thất bại',
          msg: ErrorUtils.instance.getErrorMessage(responseMessageDTO.message));
    }
  }
}
