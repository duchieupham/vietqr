// ignore_for_file: constant_identifier_names

class VietQRId {
  //Cấu trúc dữ liệu gốc gốc của VietQR trong dịch vụ chuyển nhanh NAPAS247
  //Phiên bản dữ liệu
  static const String PAYLOAD_FORMAT_INDICATOR_ID = '00';
  //Phương thức khởi tạo
  static const String POINT_OF_INITIATION_METHOD_ID = '01';
  //Thông tin định danh ĐVCNTT
  static const String MERCHANT_ACCOUNT_INFORMATION_ID = '38';
  //Mã danh mục ĐVCNTT
  static const String MERCHANT_CATEGORY_CODE_ID = '52';
  //Mã tiền tệ
  static const String TRANSACTION_CURRENCY_ID = '53';
  //Số tiền giao dịch
  static const String TRANSACTION_AMOUNT_ID = '54';
  //Chỉ thị cho Tip và phí giao dịch
  static const String TIP_OR_CONVENIENCE_INDICATOR_ID = '55';
  //Giá trị phí cố định
  static const VALUE_OF_CONVENIENCE_FEE_FIXED_ID = '56';
  //Giá trị phí tỷ lệ phần trăm
  static const String VALUE_OF_CONVENIENCE_FEE_PERCENTAGE_ID = '57';
  //Mã quốc gia
  static const String COUNTRY_CODE_ID = '58';
  //Tên ĐVCNTT
  static const String MERCHANT_NAME_ID_ID = '59';
  //Thành phố của ĐVCNTT
  static const String MERCHANT_CITY_ID = '60';
  //Mã bưu điện
  static const String POSTAL_CODE_ID = '61';
  //Thông tin bổ sung
  static const String ADDITIONAL_DATA_FIELD_TEMPLATE_ID = '62';
  //Thông tin ĐVCNTT khuân mẫu ngôn ngữ thay thế
  static const String MERCHANT_INFORMATION_LANGUAGE_TEMPLATE_ID = '64';
  //Đăng ký bởi EMVCo - RFU for EMVCo
  //65-79
  static const List<String> RFU_FOR_EMVCO = ['65', '66', '67']; //...
  //Các thông tin bổ sung đăng ký dùng trong tương lai - Unreserved Templates
  //80-99
  static const List<String> UNRESERVED_TEMPLATES_ID = ['80', '81', '82']; //...
  //Cyclic Redundancy Check
  static const String CRC_ID = '63';

  //
  //Mã dịch vụ
  static const TRANSFER_SERVCICE_CODE = '02';
}
