import 'package:vierqr/commons/enums/error_type.dart';

class ErrorUtils {
  const ErrorUtils._privateConsrtructor();

  static const ErrorUtils _instance = ErrorUtils._privateConsrtructor();

  static ErrorUtils get instance => _instance;

  String getErrorMessage(String message) {
    String result = '';
    ErrorType errorType =
        (ErrorType.values.toString().contains('ErrorType.$message') &&
                message != '')
            ? ErrorType.values.byName(message)
            : ErrorType.E04;

    switch (errorType) {
      case ErrorType.E01:
        result = 'Mật khẩu cũ không khớp';
        break;
      case ErrorType.E02:
        result = 'Tài khoản đã tồn tại';
        break;
      case ErrorType.E03:
        result = 'Không thể tạo tài khoản';
        break;
      case ErrorType.E04:
        result = 'Không thể thực hiện thao tác này. Vui lòng thử lại sau';
        break;
      case ErrorType.E05:
        result = 'Đã có lỗi xảy ra, vui lòng thử lại sau';
        break;
      case ErrorType.E06:
        result =
            'Không thể liên kết. Tài khoản ngân hàng này đã được thêm trước đó';
        break;
      case ErrorType.E07:
        result = 'Thành viên không tồn tài trong hệ thống';
        break;
      case ErrorType.E08:
        result = 'Thành viên đã được thêm vào tài khoản trước đó';
        break;
      case ErrorType.E09:
        result = 'Không thể thêm thành viên vào tài khoản';
        break;
      case ErrorType.E10:
        result = 'Không thể thêm mẫu nội dung chuyển khoản';
        break;
      case ErrorType.E11:
        result = 'Không thể xoá mẫu nội dung chuyển khoản';
        break;
      case ErrorType.E12:
        result =
            'Không thể liên kết. Tài khoản thanh toán này đã được thêm trước đó';
        break;
      case ErrorType.E13:
        result = 'Thêm tài khoản thanh toán thất bại';
        break;
      case ErrorType.E14:
        result = 'Không thể tạo doanh nghiệp';
        break;
      case ErrorType.E15:
        result = 'CMND/CCCD không hợp lệ';
        break;
      case ErrorType.E16:
        result = 'Trạng thái TK ngân hàng không hợp lệ';
        break;
      case ErrorType.E17:
        result = 'TK ngân hàng không hợp lệ';
        break;
      case ErrorType.E18:
        result = 'Tên chủ TK không hợp lệ';
        break;
      case ErrorType.E19:
        result = 'Số điện thoại không hợp lệ';
        break;
      case ErrorType.E20:
        result = 'TK ngân hàng không tồn tại';
        break;
      case ErrorType.E21:
        result = 'Có vấn đề xảy ra khi gửi OTP. Vui lòng thử lại sau';
        break;
      case ErrorType.E22:
        result = 'Không thể đăng ký nhận BĐSD. Vui lòng thử lại sau';
        break;
      case ErrorType.E23:
        result = 'TK đã được liên kết với hệ thống';
        break;
      case ErrorType.E46:
        result = 'Có vấn đề xảy ra khi thực hiện yêu cầu. Vui lòng thử lại sau';
        break;
      case ErrorType.E55:
        result = 'Xác nhận mật khẩu sai.';
        break;
      case ErrorType.E56:
        result = 'Hệ thống đang xảy ra vấn đề. Vui lòng thử lại sau.';
        break;
      case ErrorType.E57:
        result =
            'Số điện thoại không đúng định dạng. Vui lòng kiểm tra lại thông tin trên và thực hiện lại.';
        break;
      case ErrorType.E58:
        result =
            'Nhà mạng không hợp lệ. Vui lòng kiểm tra lại thông tin trên và thực hiện lại.';
        break;
      case ErrorType.E59:
        result = 'Hệ thống đang xảy ra vấn đề. Vui lòng thử lại sau.';
        break;
      case ErrorType.E60:
        result = 'Hệ thống đang xảy ra vấn đề. Vui lòng thử lại sau.';
        break;
      case ErrorType.E61:
        result =
            'Số dư VQR không đủ. Vui lòng nạp thêm VQR để thực hiện nạp tiền điện thoại';
        break;
      case ErrorType.E62:
        result = 'Giao dịch thất bại.';
        break;
      case ErrorType.E63:
        result = 'Hệ thống nạp tiền đang bảo trì. Vui lòng thử lại sau';
        break;
      case ErrorType.E64:
        result = 'Hệ thống nạp tiền đang bận. Vui lòng thử lại sau';
        break;
      case ErrorType.E65:
        result = 'Xác thực thất bại. Vui lòng thử lại sau';
        break;
      case ErrorType.E70:
        result = 'Phương thức thanh toán không hợp lệ';
        break;
      case ErrorType.C03:
        result = 'Tài khoản này đã được thêm trước đó';
        break;
      case ErrorType.E110:
        result = 'Mã nhóm đã tồn tại trong hệ thống';
        break;
      case ErrorType.E112:
        result =
            'Tài khoản đã đăng ký dịch vụ thanh toán định danh. Vui lòng kiểm tra lại thông tin.';
        break;
      case ErrorType.E117:
        result =
            'Không tìm thấy chứng minh thư/Mã số thuế trên hệ thống ngân hàng. Vui lòng kiểm tra lại thông tin.';
        break;
      case ErrorType.E118:
        result =
            'Không tìm thấy số điện thoại trên hệ thống ngân hàng. Vui lòng kiểm tra lại thông tin.';
        break;
      case ErrorType.E119:
        result =
            'Số tài khoản không tồn tại trên hệ thống ngân hàng. Vui lòng kiểm tra lại thông tin.';
        break;
      case ErrorType.E120:
        result =
            'Tài khoản khách hàng bị tạm giữ. Vui lòng liên hệ với ngân hàng thụ hưởng để kiểm tra vấn đề.';
        break;
      case ErrorType.E121:
        result =
            'Tài khoản thanh toán không hoạt động. Vui lòng liên hệ với ngân hàng thụ hưởng để kiểm tra vấn đề.';
        break;
      case ErrorType.E122:
        result =
            'Trạng thái đăng ký dịch vụ BIDV Online không hợp lệ. Vui lòng liên hệ với ngân hàng thụ hưởng để kiểm tra vấn đề.';
        break;
      case ErrorType.E123:
        result =
            'Quý khách chưa đăng ký dịch vụ E-Banking (BIDV Online/BIDV SmartBanking) hoặc dịch vụ đang KHÔNG ở trạng thái hoạt động. Vui lòng liên hệ với ngân hàng thụ hưởng để kiểm tra vấn đề.';
        break;
      case ErrorType.E124:
        result =
            'Có lỗi trong quá trình xác thực OTP (Mã OTP không hợp lệ). Vui lòng thử lại sau.';
        break;
      case ErrorType.E125:
        result =
            'Có lỗi trong quá trình xác thực OTP hoặc khách hàng bị khóa OTP tạm thời do nhập sai OTP 5 lần liên tiếp. Vui lòng thử lại sau.';
        break;
      case ErrorType.E133:
        result =
            'Không tìm thấy thông tin tài khoản ngân hàng. Vui lòng kiểm tra lại thông tin.';
        break;
      default:
        result = message;
    }
    return result;
  }
}
