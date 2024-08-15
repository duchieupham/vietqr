import 'package:vierqr/commons/utils/string_utils.dart';

class RegisterUtils {
  const RegisterUtils._privateConsrtructor();

  static const RegisterUtils _instance = RegisterUtils._privateConsrtructor();

  static RegisterUtils get instance => _instance;

  bool isValidValidation(
      bool isPhoneErr, bool isPasswordErr, bool isConfirmPassErr) {
    return !isPhoneErr && !isPasswordErr && !isConfirmPassErr;
  }

  bool isValid(bool isPhoneErr, bool isPasswordErr) {
    return !isPhoneErr && !isPasswordErr;
  }

  bool isEnableButton(
      String phoneNumber,
      String password,
      String confirmPassword,
      bool isPhoneErr,
      bool isPasswordErr,
      bool isConfirmPassErr) {
    if (phoneNumber.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      if (isValidValidation(isPhoneErr, isPasswordErr, isConfirmPassErr)) {
        return true;
      }
    }
    return false;
  }

  bool isEnableButtonPhone(String phoneNumber) {
    if (phoneNumber.isNotEmpty) {
      String phone = phoneNumber.replaceAll(' ', '');
      var isValid = StringUtils.instance.isValidatePhone(phone);
      return isValid;
    }
    return false;
  }

  bool isValidValidationPassword(bool isPhoneErr, bool isPasswordErr) {
    return !isPhoneErr && !isPasswordErr;
  }

  bool isEnableButtonPassword(String phoneNumber, String password,
      bool isPhoneErr, bool isPasswordErr) {
    if (phoneNumber.isNotEmpty && password.isNotEmpty) {
      if (isValidValidationPassword(isPhoneErr, isPasswordErr)) {
        return true;
      }
    }
    return false;
  }
}
