// ignore_for_file: constant_identifier_names

import 'package:vierqr/commons/constants/vietqr/country_code.dart';
import 'package:vierqr/commons/constants/vietqr/transaction_currency.dart';

class VietQRValue {
  //Payload Format Indicator value
  static const String PAYLOAD_FORMAT_INDICATOR_VALUE = '01';
  //Point of Initiation Method value
  //phương thức khởi tạo dùng cho QR tĩnh - sử dụng QR được nhiều liền
  static const String POINT_OF_INITIATION_METHOD_VALUE_STATIC = '11';
  //phương thức khởi tạo dùng cho QR động - sử dụng QR chỉ được 1 lần duy nhất
  static const String POINT_OF_INITIATION_METHOD_VALUE = '12';
  //Transaction Currency value
  static const String TRANSACTION_CURRENCY_VALUE = TransactionCurrency.VND;
  //Country Code value
  static const String COUNTRY_CODE_VALUE = CountryCode.VIETNAM;
  //CRC (Cyclic Redundancy Check) default length
  static const String CRC_LENGTH = '04';
}
