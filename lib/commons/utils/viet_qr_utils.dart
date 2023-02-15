// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:vierqr/commons/constants/vietqr/aid.dart';
import 'package:vierqr/commons/constants/vietqr/cai_bank.dart';
import 'package:vierqr/commons/constants/vietqr/qr_guid.dart';
import 'package:vierqr/commons/constants/vietqr/transfer_service_code.dart';
import 'package:vierqr/commons/constants/vietqr/viet_qr_id.dart';
import 'package:vierqr/commons/constants/vietqr/viet_qr_value.dart';
import 'package:vierqr/commons/enums/bank_name.dart';
import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/models/viet_qr_generate_dto.dart';
import 'package:crclib/catalog.dart';
import 'package:crclib/crclib.dart';

class VietQRUtils {
  const VietQRUtils._privateConsrtructor();

  static const VietQRUtils _instance = VietQRUtils._privateConsrtructor();
  static VietQRUtils get instance => _instance;

//Tạo QR không bao gồm giá tiền
  String generateVietQRWithoutTransactionAmount(VietQRGenerateDTO dto) {
    String result = '';
    //Một đối tượng dữ liệu bao gồm: ID + Chiều dài + giá trị
    //Payload Format Indicator
    String pfi = VietQRId.PAYLOAD_FORMAT_INDICATOR_ID +
        generateLengthOfValue(VietQRValue.PAYLOAD_FORMAT_INDICATOR_VALUE) +
        VietQRValue.PAYLOAD_FORMAT_INDICATOR_VALUE;
    //Point of Initiation Method
    String poim = VietQRId.POINT_OF_INITIATION_METHOD_ID +
        generateLengthOfValue(VietQRValue.POINT_OF_INITIATION_METHOD_VALUE) +
        VietQRValue.POINT_OF_INITIATION_METHOD_VALUE;
    //Consumer Account Information
    String cai = VietQRId.MERCHANT_ACCOUNT_INFORMATION_ID +
        generateLengthOfValue(dto.cAIValue) +
        dto.cAIValue;
    //Transaction Currency
    String tc = VietQRId.TRANSACTION_CURRENCY_ID +
        generateLengthOfValue(VietQRValue.TRANSACTION_CURRENCY_VALUE) +
        VietQRValue.TRANSACTION_CURRENCY_VALUE;
    //Country Code
    String cc = VietQRId.COUNTRY_CODE_ID +
        generateLengthOfValue(VietQRValue.COUNTRY_CODE_VALUE) +
        VietQRValue.COUNTRY_CODE_VALUE;
    //Additional Data Field Template
    // String adft = VietQRId.ADDITIONAL_DATA_FIELD_TEMPLATE_ID +
    //   generateLengthOfValue(dto.additionalDataFieldTemplateValue) +
    // dto.additionalDataFieldTemplateValue;
    //CRC ID + CRC Length + CRC value (Cyclic Redundancy Check)
    String crcValue = generateCRC(pfi +
        poim +
        cai +
        tc +
        cc +
        //  adft +
        VietQRId.CRC_ID +
        VietQRValue.CRC_LENGTH);
    String crc = VietQRId.CRC_ID + VietQRValue.CRC_LENGTH + crcValue;
    result = pfi + poim + cai + tc + cc /*+ adft*/ + crc;
    return result;
  }

//Tạo QR động đến tài khoản
  String generateVietQR(VietQRGenerateDTO dto) {
    String result = '';
    //Một đối tượng dữ liệu bao gồm: ID + Chiều dài + giá trị
    //Payload Format Indicator
    String pfi = VietQRId.PAYLOAD_FORMAT_INDICATOR_ID +
        generateLengthOfValue(VietQRValue.PAYLOAD_FORMAT_INDICATOR_VALUE) +
        VietQRValue.PAYLOAD_FORMAT_INDICATOR_VALUE;
    //Point of Initiation Method
    String poim = VietQRId.POINT_OF_INITIATION_METHOD_ID +
        generateLengthOfValue(VietQRValue.POINT_OF_INITIATION_METHOD_VALUE) +
        VietQRValue.POINT_OF_INITIATION_METHOD_VALUE;
    //Consumer Account Information
    String cai = VietQRId.MERCHANT_ACCOUNT_INFORMATION_ID +
        generateLengthOfValue(dto.cAIValue) +
        dto.cAIValue;
    //Transaction Currency
    String tc = VietQRId.TRANSACTION_CURRENCY_ID +
        generateLengthOfValue(VietQRValue.TRANSACTION_CURRENCY_VALUE) +
        VietQRValue.TRANSACTION_CURRENCY_VALUE;
    //Transaction Amount
    String ta = VietQRId.TRANSACTION_AMOUNT_ID +
        generateLengthOfValue(dto.transactionAmountValue) +
        dto.transactionAmountValue;
    //Country Code
    String cc = VietQRId.COUNTRY_CODE_ID +
        generateLengthOfValue(VietQRValue.COUNTRY_CODE_VALUE) +
        VietQRValue.COUNTRY_CODE_VALUE;
    //Additional Data Field Template
    String adft = '';
    if (dto.additionalDataFieldTemplateValue.isNotEmpty) {
      adft = VietQRId.ADDITIONAL_DATA_FIELD_TEMPLATE_ID +
          generateLengthOfValue(dto.additionalDataFieldTemplateValue) +
          dto.additionalDataFieldTemplateValue;
    } else {
      adft = VietQRId.ADDITIONAL_DATA_FIELD_TEMPLATE_ID +
          generateLengthOfValue(' ') +
          ' ';
    }
    //CRC ID + CRC Length + CRC value (Cyclic Redundancy Check)
    String crcValue = '';
    if (dto.additionalDataFieldTemplateValue.isEmpty) {
      crcValue = generateCRC(pfi +
          poim +
          cai +
          tc +
          ta +
          cc +
          VietQRId.CRC_ID +
          VietQRValue.CRC_LENGTH);
      String crc = VietQRId.CRC_ID + VietQRValue.CRC_LENGTH + crcValue;
      result = pfi + poim + cai + tc + ta + cc + crc;
    } else {
      crcValue = generateCRC(pfi +
          poim +
          cai +
          tc +
          ta +
          cc +
          adft +
          VietQRId.CRC_ID +
          VietQRValue.CRC_LENGTH);
      String crc = VietQRId.CRC_ID + VietQRValue.CRC_LENGTH + crcValue;
      result = pfi + poim + cai + tc + ta + cc + adft + crc;
    }
    return result;
  }

//Trả về thông tin độ dài của một chuỗi
  String generateLengthOfValue(String value) {
    String result = '';
    if (value.isNotEmpty) {
      int valueLength = value.length;
      if (valueLength < 10) {
        result = '0$valueLength';
      } else {
        result = valueLength.toString();
      }
    }
    return result;
  }

//Tạo mã CRC theo chuẩn CRC-16/CCITT-FALSE
  String generateCRC(String value) {
    String result = '';
    CrcValue crcValue = Crc16CcittFalse().convert(utf8.encode(value));
    result = crcValue.toRadixString(16).toString().toUpperCase();
    return result;
  }

  //Tạo mã thông tin định danh
  //poimValue = BNB ID + Consumer ID
  //- Định danh ACQ ID/ BNB ID: các ngân hàng tại Việt Nam sử dụng mã BIN cấp bởi
  //NHNN. VD: 970403.
  //- Định danh Merchant ID/ Consumer ID có định dạng chữ số (ANS) với độ dài tối đa 19
  // ký tự. Giá trị của Merchant ID có thể là Mã số thuế, mã số doanh nghiệp, mã số đăng
  // ký hộ kinh doanh hoặc mã định danh, chuỗi ký tự tùy chọn theo quy định cụ thể của
  // ngân hàng thanh toán. Giá trị của Consumer ID là số tài khoản của khách hàng mở tại
  // NH thụ hưởng (BNB ID).
  String generateMerchantAccountInformationValue(String poimValue) {
    String result = '';
    //Định danh duy nhất toàn cầu
    String guid = VietQRId.PAYLOAD_FORMAT_INDICATOR_ID +
        generateLengthOfValue(AID.AID_NAPAS) +
        AID.AID_NAPAS;
    //Tổ chức thụ hưởng
    String poim = VietQRId.POINT_OF_INITIATION_METHOD_ID +
        generateLengthOfValue(poimValue) +
        poimValue;
    //Mã dịch vụ - Transfer Service code
    String tsc = VietQRId.TRANSFER_SERVCICE_CODE +
        generateLengthOfValue(
            TransferServiceCode.QUICK_TRANSFER_FROM_QR_TO_BANK_ACCOUNT) +
        TransferServiceCode.QUICK_TRANSFER_FROM_QR_TO_BANK_ACCOUNT;
    result = guid + poim + tsc;
    return result;
  }

  String generateCAIValue(String bankName, String bankAccount) {
    String result = '';
    if (BankInformationUtil.instance.checkAvailableGenerateBank(bankName)) {
      String middleCAIValue = '';
      String caiBank = '';
      //
      if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.TECHCOMBANK.toString()) {
        caiBank = CAIBank.MID_CAI_TECHCOMBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.SHB.toString()) {
        caiBank = CAIBank.MID_CAI_SHB;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.VIETCOMBANK.toString()) {
        caiBank = CAIBank.MID_CAI_VIETCOMBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.SHB.toString()) {
        caiBank = CAIBank.MID_CAI_SHB;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.BIDV.toString()) {
        caiBank = CAIBank.MID_CAI_BIDV;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.AGRIBANK.toString()) {
        caiBank = CAIBank.MID_CAI_AGRIBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.OCB.toString()) {
        caiBank = CAIBank.MID_CAI_OCB;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.MB.toString()) {
        caiBank = CAIBank.MID_CAI_MBBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.ACB.toString()) {
        caiBank = CAIBank.MID_CAI_ACB;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.VPBANK.toString()) {
        caiBank = CAIBank.MID_CAI_VPBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.TPBANK.toString()) {
        caiBank = CAIBank.MID_CAI_TPBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.VIETINBANK.toString()) {
        caiBank = CAIBank.MID_CAI_VIETINBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.SACOMBANK.toString()) {
        caiBank = CAIBank.MID_CAI_SACOMBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.HDBANK.toString()) {
        caiBank = CAIBank.MID_CAI_HDBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.VIETCAPITALBANK.toString()) {
        caiBank = CAIBank.MID_CAI_VIETCAPITALBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.SCB.toString()) {
        caiBank = CAIBank.MID_CAI_SCB;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.VIB.toString()) {
        caiBank = CAIBank.MID_CAI_VIB;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.EXIMBANK.toString()) {
        caiBank = CAIBank.MID_CAI_EXIMBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.MSB.toString()) {
        caiBank = CAIBank.MID_CAI_MSB;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.CAKE.toString()) {
        caiBank = CAIBank.MID_CAI_CAKE;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.UBANK.toString()) {
        caiBank = CAIBank.MID_CAI_UBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.VIETTELMONEY.toString()) {
        caiBank = CAIBank.MID_CAI_VIETTELMONEY;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.VNPTMONEY.toString()) {
        caiBank = CAIBank.MID_CAI_VNPTMONEY;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.SAIGONBANK.toString()) {
        caiBank = CAIBank.MID_CAI_SAIGONBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.BACABANK.toString()) {
        caiBank = CAIBank.MID_CAI_BACABANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.PVCOMBANK.toString()) {
        caiBank = CAIBank.MID_CAI_PVCOMBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.OCEANBANK.toString()) {
        caiBank = CAIBank.MID_CAI_OCEANBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.NCB.toString()) {
        caiBank = CAIBank.MID_CAI_NCB;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.SINHANBANK.toString()) {
        caiBank = CAIBank.MID_CAI_SINHANBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.ABBANK.toString()) {
        caiBank = CAIBank.MID_CAI_ABBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.VIETABANK.toString()) {
        caiBank = CAIBank.MID_CAI_VIETABANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.NAMABANK.toString()) {
        caiBank = CAIBank.MID_CAI_NAMABANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.PGBANK.toString()) {
        caiBank = CAIBank.MID_CAI_PGBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.VIETBANK.toString()) {
        caiBank = CAIBank.MID_CAI_VIETBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.BAOVIETBANK.toString()) {
        caiBank = CAIBank.MID_CAI_BAOVIETBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.SEABANK.toString()) {
        caiBank = CAIBank.MID_CAI_SEABANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.COOPBANK.toString()) {
        caiBank = CAIBank.MID_CAI_COOPBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.LIENVIETPOSTBANK.toString()) {
        caiBank = CAIBank.MID_CAI_LIENVIETPOSTBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.KIENLONGBANK.toString()) {
        caiBank = CAIBank.MID_CAI_KIENLONGBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.KBANK.toString()) {
        caiBank = CAIBank.MID_CAI_KBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.VRB.toString()) {
        caiBank = CAIBank.MID_CAI_VRB;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.STANDARDCHARTERED.toString()) {
        caiBank = CAIBank.MID_CAI_STANDARDCHARTERED;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.NONGHYUP.toString()) {
        caiBank = CAIBank.MID_CAI_NONGHYUP;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.INDOVINABANK.toString()) {
        caiBank = CAIBank.MID_CAI_INDOVINABANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.IBKHCM.toString()) {
        caiBank = CAIBank.MID_CAI_IBKHCM;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.KOOKMINHCM.toString()) {
        caiBank = CAIBank.MID_CAI_KOOKMINHCM;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.KOOKMINHN.toString()) {
        caiBank = CAIBank.MID_CAI_KOOKMINHN;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.WOORI.toString()) {
        caiBank = CAIBank.MID_CAI_WOORI;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.HSBC.toString()) {
        caiBank = CAIBank.MID_CAI_HSBC;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.CBBANK.toString()) {
        caiBank = CAIBank.MID_CAI_CBBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.IBKHN.toString()) {
        caiBank = CAIBank.MID_CAI_IBKHN;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.CIMB.toString()) {
        caiBank = CAIBank.MID_CAI_CIMB;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.IBKHN.toString()) {
        caiBank = CAIBank.MID_CAI_IBKHN;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.DBSBANK.toString()) {
        caiBank = CAIBank.MID_CAI_DBSBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.DONGABANK.toString()) {
        caiBank = CAIBank.MID_CAI_DONGABANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.GPBANK.toString()) {
        caiBank = CAIBank.MID_CAI_GPBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.PUBLICBANK.toString()) {
        caiBank = CAIBank.MID_CAI_PUBLICBANK;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.UNITEDOVERSEAS.toString()) {
        caiBank = CAIBank.MID_CAI_UNITEDOVERSEAS;
      } else if (BankInformationUtil.instance.getBankName(bankName) ==
          BANKNAME.HONGLEONG.toString()) {
        caiBank = CAIBank.MID_CAI_HONGLEONG;
      }

      middleCAIValue = '0006' +
          caiBank +
          VietQRValue.PAYLOAD_FORMAT_INDICATOR_VALUE +
          VietQRUtils.instance.generateLengthOfValue(bankAccount) +
          bankAccount;
      result = QRGuid.GUID +
          VietQRId.POINT_OF_INITIATION_METHOD_ID +
          VietQRUtils.instance.generateLengthOfValue(middleCAIValue) +
          middleCAIValue +
          VietQRId.TRANSFER_SERVCICE_CODE +
          VietQRUtils.instance.generateLengthOfValue(
              TransferServiceCode.QUICK_TRANSFER_FROM_QR_TO_BANK_ACCOUNT) +
          TransferServiceCode.QUICK_TRANSFER_FROM_QR_TO_BANK_ACCOUNT;
    }
    return result;
  }
}
