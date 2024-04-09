import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/features/customer_va/widgets/customer_va_header_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/services/providers/customer_va/customer_va_insert_provider.dart';

class CustomerVAInsertMerchantView extends StatefulWidget {
  const CustomerVAInsertMerchantView({super.key});

  @override
  State<StatefulWidget> createState() => _CustomerVAInsertMerchantView();
}

class _CustomerVAInsertMerchantView
    extends State<CustomerVAInsertMerchantView> {
  String _value = '';

  @override
  void initState() {
    super.initState();
    //initital / reset service
    Provider.of<CustomerVaInsertProvider>(context, listen: false).doInit();
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
                  height: 50,
                ),
                Text(
                  'Đầu tiên, vui lòng cung cấp tên\ndoanh nghiệp / tổ chức của bạn',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
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
                  maxLength: 20,
                  onChange: (value) {
                    _value = value;
                    setState(() {});
                    Provider.of<CustomerVaInsertProvider>(context,
                            listen: false)
                        .updateMerchantName(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Nhập tên doanh nghiệp / tổ chức ở đây*',
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
                    return (provider.merchantNameErr)
                        ? Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Tên doanh nghiệp / tổ chức không đúng định dạng.',
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
                  '- Tên doanh nghiệp từ 4 - 20 ký tự, không chứa khoảng trắng.',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  '- Không chứa dấu Tiếng Việt, và ký tự đặc biệt.',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
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
                return ButtonWidget(
                  text: 'Tiếp tục',
                  textColor: (provider.merchantNameErr ||
                          provider.merchantName.toString().trim().isEmpty)
                      ? AppColor.BLACK
                      : AppColor.WHITE,
                  bgColor: (provider.merchantNameErr ||
                          provider.merchantName.toString().trim().isEmpty)
                      ? AppColor.GREY_VIEW
                      : AppColor.BLUE_TEXT,
                  borderRadius: 5,
                  function: () {
                    if (!provider.merchantNameErr &&
                        provider.merchantName.toString().trim().isNotEmpty) {
                      Navigator.pushNamed(
                          context, Routes.INSERT_CUSTOMER_VA_BANK_INFO);
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
}
