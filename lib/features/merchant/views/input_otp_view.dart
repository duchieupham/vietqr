import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/merchant/widgets/header_merchant_widget.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/response_message_dto.dart';

import '../merchant.dart';

class InputOTPView extends StatefulWidget {
  final Function(String, String) callBack;
  final String phone;
  final String merchantName;
  final String national;
  final ResponseMessageDTO dto;

  const InputOTPView(
      {super.key,
      required this.callBack,
      required this.phone,
      required this.merchantName,
      required this.national,
      required this.dto});

  @override
  State<InputOTPView> createState() => _InputNameStoreViewState();
}

class _InputNameStoreViewState extends State<InputOTPView> {
  late MerchantBloc bloc;
  bool isEnableButton = false;
  String _value = '';

  @override
  void initState() {
    super.initState();
    bloc = MerchantBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MerchantBloc>(
      create: (context) => bloc,
      child: BlocConsumer<MerchantBloc, MerchantState>(
        listener: (context, state) {
          if (state.status == BlocStatus.LOADING_PAGE) {
            DialogWidget.instance.openLoadingDialog();
          }

          if (state.status == BlocStatus.UNLOADING) {
            Navigator.pop(context);
          }

          if (state.request == MerchantType.CONFIRM_OTP) {
            String merchantId = '';
            if (widget.dto.data != null) {
              merchantId = widget.dto.data!.merchantId ?? '';
            }
            widget.callBack(state.vaNumber, merchantId);
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: _hideKeyBoard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderMerchantWidget(
                    nameStore: '',
                    title:
                        'Vui lòng nhập mã OTP\nđược gửi về SĐT ${widget.phone}'),
                const SizedBox(height: 16),
                MTextFieldCustom(
                  isObscureText: false,
                  maxLines: 1,
                  showBorder: false,
                  fillColor: AppColor.TRANSPARENT,
                  value: _value,
                  autoFocus: true,
                  textFieldType: TextfieldType.DEFAULT,
                  title: '',
                  hintText: '',
                  maxLength: 6,
                  inputType: TextInputType.text,
                  keyboardAction: TextInputAction.next,
                  onChange: (value) {
                    _value = value;
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Nhập mã OTP tại đây *',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: AppColor.GREY_TEXT,
                    ),
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
                const SizedBox(height: 16),
                const Spacer(),
                MButtonWidget(
                  title: 'Xác thực',
                  margin: EdgeInsets.zero,
                  isEnable: (_value.isNotEmpty && _value.length >= 6),
                  onTap: () => onConfirm(),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _hideKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void onConfirm() {
    Map<String, dynamic> param = {
      'merchantName': widget.merchantName,
      'otpNumber': _value,
    };
    param['merchantId'] = widget.dto.data?.merchantId ?? '';
    param['confirmId'] = widget.dto.data?.confirmId ?? '';
    bloc.add(ConfirmOTPEvent(param));
  }
}
