import 'package:vierqr/commons/enums/check_type.dart';

class CheckUtils {
  const CheckUtils._privateConsrtructor();

  static const CheckUtils _instance = CheckUtils._privateConsrtructor();
  static CheckUtils get instance => _instance;

  String getCheckMessage(String message) {
    String result = '';
    CheckType checkType =
        (CheckType.values.toString().contains('CheckType.$message') &&
                message != '')
            ? CheckType.values.byName(message)
            : CheckType.C02;
    switch (checkType) {
      case CheckType.C01:
        result = 'Tài khoản không tồn tại trong hệ thống';
        break;
      case CheckType.C02:
        result = 'Lỗi không xác định. Vui lòng thử lại sau';
        break;
      default:
        result = message;
    }
    return result;
  }
}
