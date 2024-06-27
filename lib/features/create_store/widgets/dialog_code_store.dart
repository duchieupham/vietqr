import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/create_store/create_store.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';

class DialogCodeStore extends StatefulWidget {
  final String codeStore;

  const DialogCodeStore({super.key, required this.codeStore});

  @override
  State<DialogCodeStore> createState() => _DialogCodeStoreState();
}

class _DialogCodeStoreState extends State<DialogCodeStore> {
  CreateStoreRepository repository = CreateStoreRepository();
  String _value = '';
  bool _isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _value = widget.codeStore;
    });
  }

  _onGetRandomCode() async {
    try {
      final result = await repository.getRandomCode();
      setState(() {
        _value = result;
        _isButtonEnabled = true;
      });
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, _value),
      child: Material(
        color: AppColor.TRANSPARENT,
        child: GestureDetector(
          onTap: _hideKeyBoard,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Mã cửa hàng',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context, ''),
                          child: Icon(Icons.close),
                        )
                      ],
                    ),
                    const SizedBox(height: 60),
                    MTextFieldCustom(
                      isObscureText: false,
                      maxLines: 1,
                      showBorder: true,
                      value: _value,
                      fillColor: Colors.white,
                      textFieldType: TextfieldType.DEFAULT,
                      title: '',
                      autoFocus: true,
                      hintText: 'Nhập mã cửa hàng',
                      inputType: TextInputType.text,
                      maxLength: 10,
                      keyboardAction: TextInputAction.next,
                      inputFormatter: [
                        FilteringTextInputFormatter.deny(
                            RegExp(r'[^\w\s]', caseSensitive: false)),
                      ],
                      onChange: (value) {
                        setState(() {
                          _value = value;
                          _isButtonEnabled = value.length == 10;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: AppColor.GREY_TEXT),
                        children: [
                          TextSpan(text: 'Tối đa 10 ký tự.\n'),
                          TextSpan(
                              text:
                                  'Không chứa tiếng việt và ký tự đặc biệt.\n'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: _onGetRandomCode,
                      child: Center(
                        child: Text(
                          'Tạo mã cửa hàng ngẫu nhiên',
                          style: TextStyle(
                              color: AppColor.BLUE_TEXT,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    MButtonWidget(
                      title: 'Áp dụng',
                      margin: EdgeInsets.zero,
                      colorDisableBgr: AppColor.GREY_BUTTON,
                      isEnable: _isButtonEnabled,
                      onTap: () => Navigator.pop(context, _value),
                    ),
                  ],
                ),
              ),
              if (MediaQuery.of(context).viewInsets.bottom != 0)
                const SizedBox(height: 140),
            ],
          ),
        ),
      ),
    );
  }

  void _hideKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
