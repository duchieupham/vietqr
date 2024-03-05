import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/features/merchant/widgets/header_merchant_widget.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';

class InputNameOrderView extends StatefulWidget {
  final Function(String) callBack;
  final String orderName;

  const InputNameOrderView(
      {super.key, required this.callBack, required this.orderName});

  @override
  State<InputNameOrderView> createState() => _InputNameStoreViewState();
}

class _InputNameStoreViewState extends State<InputNameOrderView> {
  bool isEnableButton = false;
  String _value = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _value = widget.orderName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _hideKeyBoard,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            Text(
              'Đầu tiên, vui lòng nhập tiêu đề\nhoá đơn của bạn.',
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
              decoration: InputDecoration(
                hintText: 'Nhập tiêu đề hoá đơn ở đây',
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
              title: 'Tiếp tục',
              margin: EdgeInsets.zero,
              isEnable: true,
              onTap: () => widget.callBack.call(_value),
            )
          ],
        ),
      ),
    );
  }

  void _hideKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
