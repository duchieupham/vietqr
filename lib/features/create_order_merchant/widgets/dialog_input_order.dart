import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/features/create_order_merchant/views/input_order_second.dart';
import 'package:vierqr/features/store/create_store/responsitory/create_store_responsitory.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';

class DialogInputOrder extends StatefulWidget {
  final Function(OrderData) onDone;

  const DialogInputOrder({super.key, required this.onDone});

  @override
  State<DialogInputOrder> createState() => _DialogInputOrderState();
}

class _DialogInputOrderState extends State<DialogInputOrder> {
  CreateStoreRepository repository = CreateStoreRepository();
  String name = '';
  String des = '';
  String price = '';
  String quantity = '1';
  String amount = '';
  OrderData data = OrderData();

  String getAmount(String a, String b) {
    String _price = a.replaceAll(',', '');
    String _quantity = b.replaceAll(',', '');

    String text =
        '${int.parse(_price.isNotEmpty ? a : '0') * int.parse(_quantity.isNotEmpty ? b : '0')}';
    return CurrencyUtils.instance.getCurrencyFormatted(text);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, name),
      child: Material(
        color: AppColor.TRANSPARENT,
        child: GestureDetector(
          onTap: _hideKeyBoard,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Danh mục mới',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context, ''),
                            child: Icon(Icons.close),
                          )
                        ],
                      ),
                      const SizedBox(height: 40),
                      MTextFieldCustom(
                        isObscureText: false,
                        maxLines: 1,
                        showBorder: true,
                        value: name,
                        fillColor: Colors.white,
                        textFieldType: TextfieldType.LABEL,
                        title: 'Tên hàng hoá ,dịch vụ*',
                        hintText: 'Nhập tên hàng hoá, dịch vụ',
                        inputType: TextInputType.text,
                        keyboardAction: TextInputAction.next,
                        onChange: (value) {
                          setState(() {
                            name = value;
                            data.name = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      MTextFieldCustom(
                        isObscureText: false,
                        maxLines: 1,
                        showBorder: true,
                        value: des,
                        fillColor: Colors.white,
                        textFieldType: TextfieldType.LABEL,
                        title: 'Mô tả hàng hoá ,dịch vụ',
                        hintText: 'Nhập mô tả hàng hoá, dịch vụ',
                        inputType: TextInputType.text,
                        keyboardAction: TextInputAction.next,
                        onChange: (value) {
                          setState(() {
                            des = value;
                            data.des = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      MTextFieldCustom(
                        isObscureText: false,
                        maxLines: 1,
                        showBorder: true,
                        value: price,
                        fillColor: Colors.white,
                        textFieldType: TextfieldType.LABEL,
                        title: 'Đơn giá',
                        hintText: 'Nhập đơn giá',
                        suffixIcon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('VND'),
                          ],
                        ),
                        inputType: TextInputType.number,
                        keyboardAction: TextInputAction.next,
                        onChange: (value) {
                          setState(() {
                            price = CurrencyUtils.instance
                                .getCurrencyFormatted(value);
                            amount =
                                getAmount(value.replaceAll(',', ''), quantity);
                            data.price = price.replaceAll(',', '');
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      MTextFieldCustom(
                        isObscureText: false,
                        maxLines: 1,
                        showBorder: true,
                        value: quantity,
                        fillColor: Colors.white,
                        textFieldType: TextfieldType.LABEL,
                        title: 'Số lượng',
                        hintText: 'Nhập số lượng',
                        inputType: TextInputType.number,
                        keyboardAction: TextInputAction.next,
                        onChange: (value) {
                          setState(() {
                            data.quantity = value;
                            quantity = value;
                            amount =
                                getAmount(price.replaceAll(',', ''), quantity);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: AppColor.GREY_TEXT.withOpacity(0.3)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Thành tiền:'),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(color: AppColor.BLACK),
                                  children: [
                                    TextSpan(
                                      text: amount.isNotEmpty ? amount : '0',
                                      style: TextStyle(
                                          color: AppColor.ORANGE_DARK,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    TextSpan(
                                      text: ' VND',
                                      style: TextStyle(
                                          color: AppColor.ORANGE_DARK,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        MButtonWidget(
                          title: 'Hoàn tất',
                          isEnable: data.isEnable,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          colorDisableBgr: AppColor.GREY_TEXT.withOpacity(0.3),
                          margin: EdgeInsets.symmetric(vertical: 20),
                          onTap: () {
                            data.amount = amount.replaceAll(',', '');
                            if (data.quantity.isEmpty) {
                              data.quantity = '1';
                            }
                            widget.onDone(data);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _hideKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
