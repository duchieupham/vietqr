import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';

class InputNameMerchantView extends StatefulWidget {
  final Function(String) callBack;
  final String storeName;

  const InputNameMerchantView(
      {super.key, required this.callBack, required this.storeName});

  @override
  State<InputNameMerchantView> createState() => _InputNameStoreViewState();
}

class _InputNameStoreViewState extends State<InputNameMerchantView> {
  bool isEnableButton = false;
  String _value = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _value = widget.storeName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _hideKeyBoard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/logo-business-3D.png',
            height: 100,
          ),
          const Text(
            'Đầu tiên, vui lòng cung cấp\ntên đại lý của bạn',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
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
            inputType: TextInputType.text,
            keyboardAction: TextInputAction.next,
            onChange: (value) {
              _value = value;
              setState(() {});
            },
            decoration: const InputDecoration(
              hintText: 'Nhập tên đại lý ở đây',
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
          Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                    fontSize: 14,
                    color: AppColor.BLACK,
                    fontWeight: FontWeight.w600),
                children: [
                  TextSpan(text: 'Lưu ý:\n'),
                  TextSpan(
                    text:
                        'Tên đại lý tối đa 50 ký tự, không chứa khoảng trắng.\n',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColor.BLACK,
                        fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                    text: 'Không chứa dấu tiếng việt và ký tự đặc biệt.',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColor.BLACK,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          MButtonWidget(
            title: 'Tiếp tục',
            margin: EdgeInsets.zero,
            isEnable: true,
            onTap: () => widget.callBack.call(_value),
          )
        ],
      ),
    );
  }

  void _hideKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
