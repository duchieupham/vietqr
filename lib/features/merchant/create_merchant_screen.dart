import 'package:flutter/material.dart';
import 'package:vierqr/features/merchant/views/input_otp_view.dart';
import 'package:vierqr/features/merchant/views/insert_merchant_view.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import 'views/info_confirm_view.dart';
import 'views/input_name_merchant_view.dart';

enum CreateMerchantType {
  INPUT_NAME,
  INFO_CONFIRM,
  INPUT_OTP,
  INSERT_MERCHANT,
}

class CreateMerchantScreen extends StatefulWidget {
  final AccountBankDetailDTO bankDetail;
  static String routeName = '/merchant_screen';

  const CreateMerchantScreen({super.key, required this.bankDetail});

  @override
  State<CreateMerchantScreen> createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends State<CreateMerchantScreen> {
  CreateMerchantType step = CreateMerchantType.INPUT_NAME;
  bool isEnableButton = false;
  String _merchantName = '';
  String _phone = '';
  String _national = '';
  String vaNumber = '';
  String _merchantId = '';
  ResponseMessageDTO responseMDTO = ResponseMessageDTO(status: '', message: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
        title: 'Trở về',
        centerTitle: false,
        onPressed: _handleBack,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    Widget _body = const SizedBox();

    switch (step) {
      case CreateMerchantType.INFO_CONFIRM:
        Map<String, dynamic> param = {
          'merchantName': _merchantName,
          'bankAccount': widget.bankDetail.bankAccount,
          'bankCode': widget.bankDetail.bankCode,
          'userBankName': widget.bankDetail.userBankName,
        };
        _body = InfoConfirmView(
          callBack: _onHandleInputConfirm,
          nameStore: _merchantName,
          phone: _phone,
          national: _national,
          paramOTP: param,
        );
        break;
      case CreateMerchantType.INPUT_OTP:
        _body = InputOTPView(
          callBack: _onHandleInputOTP,
          phone: _phone,
          national: _national,
          merchantName: _merchantName,
          dto: responseMDTO,
        );
        break;
      case CreateMerchantType.INSERT_MERCHANT:
        Map<String, dynamic> param = {
          'merchantName': _merchantName,
          'merchantId': _merchantId,
          'bankId': widget.bankDetail.id,
          'userId': SharePrefUtils.getProfile().userId,
          'bankAccount': widget.bankDetail.bankAccount,
          'userBankName': widget.bankDetail.userBankName,
          'nationalId': _national,
          'phoneAuthenticated': _phone,
          'vaNumber': vaNumber,
          'bankShortName': widget.bankDetail.bankShortName,
        };
        _body = InsertMerchantView(param: param);
        break;

      default:
        _body = InputNameMerchantView(
          callBack: _onHandleInputName,
          storeName: _merchantName,
        );
    }

    return _body;
  }

  void _onHandleInputName(String value) {
    setState(() {
      step = CreateMerchantType.INFO_CONFIRM;
      _merchantName = value;
      _phone = '';
      _national = '';
      responseMDTO = ResponseMessageDTO(status: '', message: '');
    });
  }

  void _onHandleInputConfirm(
      String phone, String national, ResponseMessageDTO responseMessageDTO) {
    setState(() {
      _phone = phone;
      _national = national;
      vaNumber = '';
      _merchantId = '';
      responseMDTO = responseMessageDTO;
      step = CreateMerchantType.INPUT_OTP;
    });
  }

  void _onHandleInputOTP(String value, String merchantId) {
    setState(() {
      vaNumber = value;
      _merchantId = merchantId;
      step = CreateMerchantType.INSERT_MERCHANT;
    });
  }

  void _handleBack() {
    switch (step) {
      case CreateMerchantType.INPUT_NAME:
        Navigator.pop(context);
        break;
      case CreateMerchantType.INFO_CONFIRM:
        step = CreateMerchantType.INPUT_NAME;
        setState(() {});
        break;
      case CreateMerchantType.INPUT_OTP:
        step = CreateMerchantType.INFO_CONFIRM;
        setState(() {});
        break;
      case CreateMerchantType.INSERT_MERCHANT:
        step = CreateMerchantType.INPUT_OTP;
        setState(() {});
        break;
    }
  }
}
