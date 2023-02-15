import 'package:vierqr/commons/enums/bank_name.dart';

class BankInformationUtil {
  const BankInformationUtil._privateConsrtructor();

  static const BankInformationUtil _instance =
      BankInformationUtil._privateConsrtructor();
  static BankInformationUtil get instance => _instance;

  bool checkBankAddress(String bankName) {
    bool result = false;
    //
    //to fake data to check SMS
    if (bankName == '0909000999') {
      bankName = 'MB Bank';
    }
    if (bankName == '0900000000') {
      bankName = 'Vietin Bank';
    }
    if (bankName == '0909999999') {
      bankName = 'SHB';
    }
    if (bankName == '0909090909') {
      bankName = 'Techcombank';
    }
    if (bankName == '0909090901') {
      bankName = 'SCB';
    }
    if (bankName == '0909090902') {
      bankName = 'VietcomBank';
    }
    //
    bankName = 'BANKNAME.${bankName.trim().replaceAll(' ', '').toUpperCase()}';
    if (BANKNAME.values.toString().contains(bankName)) {
      result = true;
    }
    return result;
  }

  bool checkAvailableAddress(String bankName) {
    bool result = false;

    //to fake data to check SMS
    if (bankName == '0909000999') {
      bankName = 'MB Bank';
    }
    if (bankName == '0900000000') {
      bankName = 'Vietin Bank';
    }
    if (bankName == '0909999999') {
      bankName = 'SHB';
    }
    if (bankName == '0909090909') {
      bankName = 'Techcombank';
    }
    if (bankName == '0909090901') {
      bankName = 'SCB';
    }
    if (bankName == '0909090902') {
      bankName = 'VietcomBank';
    }
    //
    bankName = 'BANKNAME.${bankName.trim().replaceAll(' ', '').toUpperCase()}';
    if (AVAILABLE_FORMAT_BANKNAME.values.toString().contains(bankName)) {
      result = true;
    }
    return result;
  }

  bool checkAvailableGenerateBank(String bankName) {
    bool result = false;

    //to fake data to check SMS
    if (bankName == '0909000999') {
      bankName = 'MB Bank';
    }
    if (bankName == '0900000000') {
      bankName = 'Vietin Bank';
    }
    if (bankName == '0909999999') {
      bankName = 'SHB';
    }
    if (bankName == '0909090909') {
      bankName = 'Techcombank';
    }
    if (bankName == '0909090901') {
      bankName = 'SCB';
    }
    if (bankName == '0909090902') {
      bankName = 'VietcomBank';
    }
    //
    bankName = 'BANKNAME.${bankName.trim().replaceAll(' ', '').toUpperCase()}';
    if (AVAILABLE_ADD_BANKNAME.values.toString().contains(bankName)) {
      result = true;
    }
    return result;
  }

  String getBankName(String address) {
    //to fake data to check SMS
    if (address == '0909000999') {
      address = 'MB Bank';
    }
    if (address == '0900000000') {
      address = 'Vietin Bank';
    }
    if (address == '0909999999') {
      address = 'SHB';
    }
    if (address == '0909090909') {
      address = 'TechcomBank';
    }
    if (address == '0909090901') {
      address = 'SCB';
    }
    if (address == '0909090902') {
      address = 'VietcomBank';
    }
    String result =
        'BANKNAME.${address.trim().replaceAll(' ', '').toUpperCase()}';
    return result;
  }

  bool isIncome(String transaction) {
    bool result = false;
    if (transaction.trim().startsWith('+')) {
      result = true;
    }
    return result;
  }

  // String hideBankAccount(String bankAccount) {
  //   String result = '';
  //   if (bankAccount.isNotEmpty) {
  //     result = '${bankAccount.substring(0, 3)}*${bankAccount.substring(3 + 1)}';
  //     result = '${result.substring(0, 4)}*${result.substring(4 + 1)}';
  //     result = '${result.substring(0, 5)}*${result.substring(5 + 1)}';
  //     result = '${result.substring(0, 6)}*${result.substring(6 + 1)}';
  //   }
  //   return result;
  // }

  List<String> getAvailableAddingBanks() {
    List<String> result = [];
    String prefix = '';
    String suffix = '';
    for (var bankName in AVAILABLE_ADD_BANKNAME.values) {
      prefix = bankName.toString().replaceAll('AVAILABLE_ADD_BANKNAME.', '');
      if (prefix ==
          AVAILABLE_ADD_BANKNAME.SHB
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Sài Gòn - Hà Nội';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.TECHCOMBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Kỹ thương Việt Nam';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.VIETCOMBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Ngoại thương Việt Nam';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.VIETINBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Công thương Việt Nam';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.BIDV
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Đầu tư và Phát triển Việt Nam';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.AGRIBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH Nông nghiệp và Phát triển Nông thôn Việt Nam';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.OCB
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Phương Đông';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.MB
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Quân đội';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.ACB
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Á Châu';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.VPBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Việt Nam Thịnh Vượng';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.TPBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Tiên Phong';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.SACOMBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Sài Gòn Thương Tín';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.HDBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Phát triển TP HCM';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.VIETCAPITALBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'Ngân hàng Bản Việt';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.SCB
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Sài Gòn';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.VIB
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Quốc tế Việt Nam';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.EXIMBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Xuất Nhập khẩu Việt Nam';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.MSB
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Hàng Hải';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.CAKE
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP VN Thịnh Vượng - NH số CAKE by VPBank';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.UBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP VN Thịnh Vượng - NH số Ubank by VPBank';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.VIETTELMONEY
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'Tổng CT Dịch vụ số Viettel';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.VNPTMONEY
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'Trung tâm dịch vụ tài chính số VNPT';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.SAIGONBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'Trung tâm dịch vụ tài chính số VNPT';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.BACABANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Bắc Á';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.PVCOMBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Đại Chúng Việt Nam';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.OCEANBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TM TNHH MTV Đại Dương';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.NCB
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Quốc Dân';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.SINHANBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TNHH MTV Shinhan Việt Nam';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.ABBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP An Bình';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.VIETABANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Việt Á';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.NAMABANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Nam Á';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.PGBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Xăng dầu Petrolimex';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.VIETBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Việt Nam Thương Tín';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.BAOVIETBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Bảo Việt';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.SEABANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Đông Nam Á';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.COOPBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH Hợp tác xã Việt Nam';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.LIENVIETPOSTBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Bưu Điện Liên Việt';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.KIENLONGBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Kiên Long';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.KBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH Đại chúng TNHH Kasikornbank';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.VRB
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH Liên doanh Việt - Nga';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.STANDARDCHARTERED
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TNHH MTV Standard Chartered Bank VN';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.NONGHYUP
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH Nonghyup';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.INDOVINABANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TNHH Indovina';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.IBKHCM
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH Công nghiệp Hàn Quốc - Chi nhánh HCM';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.IBKHN
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH Công nghiệp Hàn Quốc - Chi nhánh HN';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.KOOKMINHCM
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH Kookmin - Chi nhánh HCM';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.KOOKMINHN
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH Kookmin - Chi nhánh HN';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.WOORI
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TNHH MTV Woori Việt Nam';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.HSBC
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TNHH MTV HSBC';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.CBBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TM TNHH MTV Xây dựng Việt Nam';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.CIMB
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TNHH MTV CIMB Việt Nam';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.DBSBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'DBS Bank Ltd';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.DONGABANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TMCP Đông Á';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.GPBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TM TNHH MTV Dầu Khí Toàn Cầu';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.PUBLICBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TNHH MTV Public Việt Nam';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.UNITEDOVERSEAS
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH United Overseas';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.HONGLEONG
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'NH TNHH MTV Hong Leong Việt Nam';
      }
      String value = '$prefix - $suffix';
      result.add(value);
    }
    return result;
  }

  String getBankNameFromSelectBox(String bankSelected) {
    String result = '';
    List<String> bankNameChars = bankSelected.split('-');
    for (int i = 0; i < bankNameChars.length; i++) {
      if (i != 0) {
        result += bankNameChars[i];
      }
    }
    return result;
  }

  String formatTransactionStatus(String status) {
    String result = '';
    if (status == 'PAID') {
      result = 'Thành công ';
    } else {
      result = 'Thất bại';
    }
    return result;
  }
}
