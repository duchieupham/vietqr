import 'package:vierqr/commons/enums/bank_name.dart';
import 'package:vierqr/models/bank_information_dto.dart';

class SmsInformationUtils {
  const SmsInformationUtils._privateConsrtructor();

  static const SmsInformationUtils _instance =
      SmsInformationUtils._privateConsrtructor();
  static SmsInformationUtils get instance => _instance;

  //transfer sms data to information
  BankInformationDTO transferSmsData(
      String bankName, String body, String? date) {
    BankInformationDTO result = const BankInformationDTO(
        address: '',
        time: '',
        transaction: '',
        accountBalance: '',
        content: '',
        bankAccount: '');
    //Viettin Bank
    if (bankName == BANKNAME.VIETINBANK.toString()) {
      List<String> data = body.split('|');
      String time =
          '${data[0].trim().split(':')[1]}:${data[0].trim().split(':')[2]}';
      String bankAccount = data[1].trim().split(':')[1];
      String transaction = data[2].trim().split(':')[1];
      transaction = transaction.replaceAll('V', ' V');
      String accountBalance = data[3].trim().split(':')[1];
      accountBalance = accountBalance.replaceAll('V', ' V');
      String content = data[4].trim().substring(3);
      content = content.substring(0, content.length - 1);
      result = BankInformationDTO(
        address: bankName.replaceAll('BANKNAME.', ''),
        time: time,
        transaction: transaction,
        accountBalance: accountBalance,
        content: content,
        bankAccount: bankAccount,
      );
    }
    //SHB
    if (bankName == BANKNAME.SHB.toString()) {
      String time = body.split('den')[1].split('la')[0];
      String bankAccount = body.split('SDTK ')[1].split(' den')[0];
      String transaction =
          '${body.split('GD moi nhat: ')[1].split('VND:')[0]}VND';
      String accountBalance = '${body.split('la ')[1].split('VND.')[0]}VND';
      String content = body.split('VND:')[1].trim();
      result = BankInformationDTO(
        address: bankName.replaceAll('BANKNAME.', ''),
        time: time,
        transaction: transaction,
        accountBalance: accountBalance,
        content: content,
        bankAccount: bankAccount,
      );
    }
    //Agribank
    //Techcombank
    if (bankName == BANKNAME.TECHCOMBANK.toString()) {
      String time = date!;
      String bankAccount = body.split('TK ')[1].split('So tien')[0].trim();
      String transaction =
          '${body.split('GD:')[1].split('So du')[0].trim()} VND';
      String accountBalance =
          '${body.split('So du:')[1].split(' ')[0].trim()} VND';
      List<String> contents = body.split('So du:')[1].split(' ');
      String content = '';
      for (int i = 0; i < contents.length; i++) {
        if (i != 0) {
          content += '${contents[i]} ';
        }
      }
      content.trim();
      result = BankInformationDTO(
        address: bankName.replaceAll('BANKNAME.', ''),
        time: time,
        transaction: transaction,
        accountBalance: accountBalance,
        content: content,
        bankAccount: bankAccount,
      );
    }
    //SCB
    if (bankName == BANKNAME.SCB.toString()) {
      String time = body.split('NGAY ')[1].split('SD DAU')[0].trim();
      String bankAccount = body.split('TK ')[1].split(' NGAY')[0].trim();
      String transaction = '';
      if (body.split(' VND')[0].contains('GIAM')) {
        transaction =
            '-${body.split('GIAM ')[1].split(' SD CUOI')[0].trim()} VND';
      } else {
        String prefix = '';
        if (body.split(' VND')[0].contains('TANG')) {
          prefix = 'TANG';
        } else if (body.split(' VND')[0].contains('CONG')) {
          prefix = 'CONG';
        } else if (body.split(' VND')[0].contains('NHAN')) {
          prefix = 'NHAN';
        }
        transaction =
            '+${body.split('$prefix ')[1].split(' SD CUOI')[0].trim()} VND';
      }
      String accountBalance =
          '${body.split('SD CUOI ')[1].split(' VND')[0].trim()} VND';
      String content = body.split('(')[1].split(')')[0].trim();
      result = BankInformationDTO(
        address: bankName.replaceAll('BANKNAME.', ''),
        time: time,
        transaction: transaction,
        accountBalance: accountBalance,
        content: content,
        bankAccount: bankAccount,
      );
    }
    //Số dư TK VCB 0011002422722 +50,000 VND lúc 14-11-2022 21:55:17. Số dư 45,619,646 VND. Ref MBVCB.2702133783.chuyen tien tu vcb sang.CT tu 0011002422722 PHAM DUC TUAN toi9000006789 PHAM DUC TUAN
    //Vietcombank
    if (bankName == BANKNAME.VIETCOMBANK.toString()) {
      String time = body.split('lúc ')[1].split('.')[0].trim();
      String bankAccount =
          body.split('TK VCB ')[1].split(' VND')[0].split(' ')[0];
      String transaction =
          '${body.split('TK VCB ')[1].split(' VND')[0].split(' ')[1]} VND';
      String accountBalance =
          '${body.split('. Số dư ')[1].split(' VND.')[0].trim()} VND';
      String content = body.split(' VND.')[1].trim();
      result = BankInformationDTO(
        address: bankName.replaceAll('BANKNAME.', ''),
        time: time,
        transaction: transaction,
        accountBalance: accountBalance,
        content: content,
        bankAccount: bankAccount,
      );
    }
    return result;
  }
}
