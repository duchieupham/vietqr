import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/check_utils.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/customer_va/repositories/customer_va_repository.dart';
import 'package:vierqr/features/customer_va/widgets/customer_va_header_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/services/providers/customer_va/customer_va_insert_provider.dart';

import '../../../commons/utils/image_utils.dart';

class CustomerVaInsertBankInfoView extends StatefulWidget {
  const CustomerVaInsertBankInfoView({super.key});

  @override
  State<StatefulWidget> createState() => _CustomerVaInsertBankInfoView();
}

class _CustomerVaInsertBankInfoView
    extends State<CustomerVaInsertBankInfoView> {
  final CustomerVaRepository customerVaRepository =
      const CustomerVaRepository();
  String _bankAccount = '';
  String _userBankName = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      appBar: CustomerVaHeaderWidget(),
      bottomNavigationBar: _bottom(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          shrinkWrap: false,
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Color(0XFFDADADA), width: 1),
                      image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: NetworkImage(
                            Provider.of<CustomerVaInsertProvider>(context,
                                    listen: false)
                                .bidvLogoUrl,
                            scale: 1.0,
                          ))),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Tiếp theo, nhập thông tin\ntài khoản BIDV của bạn',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Số tài khoản*',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            MTextFieldCustom(
              isObscureText: false,
              maxLines: 1,
              showBorder: false,
              fillColor: AppColor.TRANSPARENT,
              value: _bankAccount,
              autoFocus: true,
              textFieldType: TextfieldType.DEFAULT,
              title: '',
              hintText: '',
              inputType: TextInputType.text,
              keyboardAction: TextInputAction.next,
              maxLength: 20,
              onChange: (value) {
                _bankAccount = value;
                setState(() {});
                Provider.of<CustomerVaInsertProvider>(context, listen: false)
                    .updateBankAccount(value);
              },
              decoration: InputDecoration(
                hintText: 'Nhập số tài khoản ở đây*',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: AppColor.GREY_TEXT,
                ),
                counterText: '',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.BLUE_TEXT),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.BLUE_TEXT),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.BLUE_TEXT),
                ),
              ),
              inputFormatter: [
                LengthLimitingTextInputFormatter(50),
              ],
            ),
            Consumer<CustomerVaInsertProvider>(
              builder: (context, provider, child) {
                return (provider.bankAccountErr)
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Số tài khoản không đúng định dạng.',
                          style: TextStyle(
                            color: AppColor.RED_CALENDAR,
                            fontSize: 13,
                          ),
                        ),
                      )
                    : const SizedBox();
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Tên chủ tài khoản*',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            MTextFieldCustom(
              isObscureText: false,
              maxLines: 1,
              showBorder: false,
              fillColor: AppColor.TRANSPARENT,
              value: _userBankName,
              autoFocus: true,
              textFieldType: TextfieldType.DEFAULT,
              title: '',
              hintText: '',
              inputType: TextInputType.text,
              keyboardAction: TextInputAction.next,
              maxLength: 20,
              onChange: (value) {
                _userBankName = value;
                setState(() {});
                Provider.of<CustomerVaInsertProvider>(context, listen: false)
                    .updateUserBankName(value);
              },
              decoration: InputDecoration(
                hintText: 'Nhập tên chủ tài khoản ở đây*',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: AppColor.GREY_TEXT,
                ),
                counterText: '',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.BLUE_TEXT),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.BLUE_TEXT),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.BLUE_TEXT),
                ),
              ),
              inputFormatter: [
                LengthLimitingTextInputFormatter(50),
              ],
            ),
            Consumer<CustomerVaInsertProvider>(
              builder: (context, provider, child) {
                return (provider.userBankNameErr)
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Tên chủ tài khoản không đúng định dạng',
                          style: TextStyle(
                            color: AppColor.RED_CALENDAR,
                            fontSize: 13,
                          ),
                        ),
                      )
                    : const SizedBox();
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Lưu ý:',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '- Tên chủ tài khoản không dấu tiếng Việt.\n- Không chứa ký tự đặc biệt.',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottom() {
    return Consumer<CustomerVaInsertProvider>(
      builder: (context, provider, child) {
        bool isValidButton = (!provider.bankAccountErr &&
            provider.bankAccount.toString().trim().isNotEmpty &&
            !provider.userBankNameErr &&
            provider.userBankName.toString().trim().isNotEmpty);
        return ButtonWidget(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          text: 'Tiếp tục',
          textColor: (!isValidButton) ? AppColor.BLACK : AppColor.WHITE,
          bgColor: (!isValidButton) ? AppColor.GREY_VIEW : AppColor.BLUE_TEXT,
          borderRadius: 5,
          function: () async {
            if (isValidButton) {
              await _checkExistedLinkedBankAccountVa(provider.bankAccount);
            }
          },
        );
      },
    );
  }

  //
  Future<void> _checkExistedLinkedBankAccountVa(String bankAccount) async {
    //default BIDV
    String bankCode = 'BIDV';
    DialogWidget.instance.openLoadingDialog();
    ResponseMessageDTO result = await customerVaRepository
        .checkExistedBankAccountVa(bankAccount, bankCode);
    String status = result.status;
    String msg = '';
    if (status == 'CHECK' || status == 'CHECKED') {
      msg = CheckUtils.instance.getCheckMessage(result.message);
    } else if (status == 'FAILED') {
      msg = ErrorUtils.instance.getErrorMessage(result.message);
    }
    Navigator.pop(context);
    if (status == 'SUCCESS') {
      Navigator.pushNamed(context, Routes.INSERT_CUSTOMER_VA_BANK_AUTH);
    } else {
      DialogWidget.instance
          .openMsgDialog(title: 'Không thể đăng ký dịch vụ', msg: msg);
    }
  }
}
