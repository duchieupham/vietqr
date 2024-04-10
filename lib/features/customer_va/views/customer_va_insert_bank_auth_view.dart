import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/customer_va/repositories/customer_va_repository.dart';
import 'package:vierqr/features/customer_va/views/customer_va_policy_view.dart';
import 'package:vierqr/features/customer_va/widgets/customer_va_header_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/customer_va_request_dto.dart';
import 'package:vierqr/models/customer_va_response_otp_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/services/providers/customer_va/customer_va_insert_provider.dart';

class CustomerVaInsertBankAuthView extends StatefulWidget {
  const CustomerVaInsertBankAuthView({super.key});

  @override
  State<StatefulWidget> createState() => _CustomerVaInsertBankAuthView();
}

class _CustomerVaInsertBankAuthView
    extends State<CustomerVaInsertBankAuthView> {
  final CustomerVaRepository customerVaRepository =
      const CustomerVaRepository();
  String _nationalId = '';
  String _phoneAuthenticated = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      appBar: CustomerVaHeaderWidget(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CachedNetworkImage(
                    imageUrl: Provider.of<CustomerVaInsertProvider>(context,
                            listen: false)
                        .bidvLogoUrl,
                    height: 50,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Tiếp theo, vui lòng cung cấp\nthông tin xác thực tài khoản',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'CCCD/MST*',
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
                  value: _nationalId,
                  autoFocus: true,
                  textFieldType: TextfieldType.DEFAULT,
                  title: '',
                  hintText: '',
                  inputType: TextInputType.text,
                  keyboardAction: TextInputAction.next,
                  maxLength: 20,
                  onChange: (value) {
                    _nationalId = value;
                    setState(() {});
                    Provider.of<CustomerVaInsertProvider>(context,
                            listen: false)
                        .updateNationalId(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Nhập căn cước công dân / mã số thuế*',
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
                    return (provider.nationalIdErr)
                        ? Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Căn cước công dân / Mã số thuế không hợp lệ.',
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
                  '- Đối với tài khoản ngân hàng cá nhân, vui lòng cung cấp CCCD/CMND.',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  '- Đối với tài khoản doanh nghiệp, vui lòng cung cấp mã số thuế.',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Số điện thoại xác thực*',
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
                  value: _phoneAuthenticated,
                  autoFocus: false,
                  textFieldType: TextfieldType.DEFAULT,
                  title: '',
                  hintText: '',
                  inputType: TextInputType.text,
                  keyboardAction: TextInputAction.next,
                  maxLength: 20,
                  onChange: (value) {
                    _phoneAuthenticated = value;
                    setState(() {});
                    Provider.of<CustomerVaInsertProvider>(context,
                            listen: false)
                        .updatePhoneAuthenticated(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Nhập số điện thoại xác thực*',
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
                    return (provider.phoneAuthenticatedErr)
                        ? Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Số điện thoại xác thực không hợp lệ.',
                              style: TextStyle(
                                color: AppColor.RED_CALENDAR,
                                fontSize: 13,
                              ),
                            ),
                          )
                        : const SizedBox();
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            child: Consumer<CustomerVaInsertProvider>(
              builder: (context, provider, child) {
                bool isValidButton = (!provider.nationalIdErr &&
                    provider.nationalId.toString().trim().isNotEmpty &&
                    !provider.phoneAuthenticatedErr &&
                    provider.phoneAuthenticated.toString().trim().isNotEmpty);
                return ButtonWidget(
                  text: 'Tiếp tục',
                  textColor: (!isValidButton) ? AppColor.BLACK : AppColor.WHITE,
                  bgColor: (!isValidButton)
                      ? AppColor.GREY_VIEW
                      : AppColor.BLUE_TEXT,
                  borderRadius: 5,
                  function: () async {
                    if (isValidButton) {
                      FocusManager.instance.primaryFocus!.unfocus();
                      await showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: MaterialLocalizations.of(context)
                              .modalBarrierDismissLabel,
                          barrierColor: Colors.black45,
                          transitionDuration: const Duration(milliseconds: 200),
                          pageBuilder: (BuildContext buildContext,
                              Animation animation,
                              Animation secondaryAnimation) {
                            return CustomerVaPolicyView(
                              onTap: () async {
                                if (provider.aggreePolicy) {
                                  Navigator.pop(context);
                                  CustomerVaRequestDTO dto =
                                      CustomerVaRequestDTO(
                                    merchantName:
                                        provider.merchantName.toString().trim(),
                                    bankAccount:
                                        provider.bankAccount.toString().trim(),
                                    bankCode: 'BIDV',
                                    userBankName:
                                        provider.userBankName.toString().trim(),
                                    nationalId:
                                        provider.nationalId.toString().trim(),
                                    phoneAuthenticated: provider
                                        .phoneAuthenticated
                                        .toString()
                                        .trim(),
                                  );
                                  await _requestCustomerVaOTP(dto);
                                }
                              },
                              isAgreeWithPolicy: provider.aggreePolicy,
                              onSelectPolicy: provider.updateAgreePolicy,
                              bankAccount: provider.bankAccount,
                              bankCode: 'BIDV',
                            );
                          }).then((value) => provider.updateAgreePolicy(false));
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _requestCustomerVaOTP(CustomerVaRequestDTO dto) async {
    DialogWidget.instance.openLoadingDialog();
    dynamic result = await customerVaRepository.requestCustomerVaOTP(dto);
    String msg = ErrorUtils.instance.getErrorMessage('E05');
    if (result is ResponseObjectDTO) {
      //save data response
      Provider.of<CustomerVaInsertProvider>(context, listen: false)
          .updateMerchantIdAndConfirmId(
        result.data.merchantId,
        result.data.confirmId,
      );
      //
      Navigator.pop(context);
      Navigator.pushNamed(context, Routes.CUSTOMER_VA_CONFIRM_OTP);
    } else if (result is ResponseMessageDTO) {
      msg = ErrorUtils.instance.getErrorMessage(result.message);
      Navigator.pop(context);
      DialogWidget.instance
          .openMsgDialog(title: 'Không thể đăng ký dịch vụ', msg: msg);
    } else {
      Navigator.pop(context);
      DialogWidget.instance
          .openMsgDialog(title: 'Không thể đăng ký dịch vụ', msg: msg);
    }
  }
}
