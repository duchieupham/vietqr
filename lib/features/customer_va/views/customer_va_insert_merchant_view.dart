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
  late CustomerVaInsertProvider _provider;
  @override
  void initState() {
    super.initState();
    //initital / reset service
    _provider = Provider.of<CustomerVaInsertProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  void initData() {
    _provider.doInit();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.WHITE,
        appBar: const CustomerVaHeaderWidget(),
        bottomNavigationBar: _bottom(),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Đầu tiên, vui lòng cung cấp tên\ndoanh nghiệp / tổ chức của bạn',
                style: TextStyle(
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
                keyboardAction: TextInputAction.done,
                maxLength: 20,
                onChange: (value) {
                  _value = value;
                  setState(() {});
                  Provider.of<CustomerVaInsertProvider>(context, listen: false)
                      .updateMerchantName(value);
                },
                decoration: const InputDecoration(
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
                          child: const Text(
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
              const Text(
                'Lưu ý:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                '- Tên doanh nghiệp từ 4 - 20 ký tự, không chứa khoảng trắng.',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              const Text(
                '- Không chứa dấu Tiếng Việt, và ký tự đặc biệt.',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottom() {
    return Consumer<CustomerVaInsertProvider>(
      builder: (context, provider, child) {
        return ButtonWidget(
          margin: EdgeInsets.only(
              left: 30,
              right: 30,
              top: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 15),
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
              Navigator.pushNamed(context, Routes.INSERT_CUSTOMER_VA_BANK_INFO);
            }
          },
        );
      },
    );
  }
}
