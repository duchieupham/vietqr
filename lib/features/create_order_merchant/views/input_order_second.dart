import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/features/create_order_merchant/widgets/dialog_input_order.dart';
import 'package:vierqr/layouts/m_button_widget.dart';

class InputOrderSecondView extends StatefulWidget {
  final Function(List<OrderData>) callBack;
  final String orderName;
  final List<OrderData> listOrder;

  const InputOrderSecondView(
      {super.key,
      required this.callBack,
      required this.orderName,
      required this.listOrder});

  @override
  State<InputOrderSecondView> createState() => _InputNameStoreViewState();
}

class _InputNameStoreViewState extends State<InputOrderSecondView> {
  bool isEnableButton = false;
  String _value = '';
  List<OrderData> list = [];

  String total() {
    int _total = 0;
    for (var e in list) {
      _total += int.parse(e.amount.isNotEmpty ? e.amount : '0');
    }

    _value = _total.toString();
    setState(() {});

    return CurrencyUtils.instance.getCurrencyFormatted(_value);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _value = widget.orderName;
      list = [...widget.listOrder];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _hideKeyBoard,
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tiếp theo, vui lòng nhập các danh mục hàng hoá, dịch vụ của hoá đơn.',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                if (list.isNotEmpty)
                  ...List.generate(
                    list.length,
                    (index) {
                      OrderData dto = list[index];
                      return _buildItemCategory(dto, index);
                    },
                  ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _onAddCategory,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.GREY_TEXT.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/ic-invoice-blue.png',
                            width: 30),
                        const SizedBox(width: 20),
                        Text(
                          'Thêm danh mục mới',
                          style: TextStyle(color: AppColor.BLUE_TEXT),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColor.GREY_BG,
                border: Border(
                  top: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
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
                                text: total(),
                                style: TextStyle(
                                    color: AppColor.ORANGE_DARK,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              TextSpan(
                                text: ' VND',
                                style: TextStyle(
                                    color: AppColor.ORANGE_DARK, fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  MButtonWidget(
                    title: 'Tiếp tục',
                    isEnable: list.isNotEmpty,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 20),
                    onTap: () => widget.callBack.call(list),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onAddCategory() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return DialogInputOrder(
          onDone: (data) {
            Navigator.pop(context);
            list.add(data);
            setState(() {});
          },
        );
      },
    );
  }

  void _hideKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Widget _buildItemCategory(OrderData dto, int index) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.GREY_TEXT.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dto.name,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        dto.des,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 25,
                    height: 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColor.ORANGE_DARK.withOpacity(0.2)),
                    child: Text(
                      dto.quantity,
                      style: TextStyle(color: AppColor.ORANGE_DARK),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Đơn giá:${CurrencyUtils.instance.getCurrencyFormatted(dto.price)} VND',
                    style: TextStyle(color: AppColor.GREY_TEXT),
                  ),
                  const Spacer(),
                  Text(
                    ' ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)} VND',
                    style: TextStyle(color: AppColor.ORANGE_DARK),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: -10,
          right: -10,
          child: GestureDetector(
            onTap: () {
              setState(() {
                list.removeAt(index);
              });
            },
            child: Image.asset(
              'assets/images/ic-remove-account.png',
              width: 36,
              color: AppColor.RED_EC1010,
            ),
          ),
        )
      ],
    );
  }
}

String OrderDataToJson(List<OrderData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderData {
  String name;
  String des;
  String price;
  String quantity;
  String amount;

  OrderData({
    this.name = '',
    this.des = '',
    this.price = '',
    this.quantity = '',
    this.amount = '',
  });

  bool get isEnable => name.isNotEmpty && price.isNotEmpty;

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": des,
        "quantity": int.parse(quantity),
        "amount": int.parse(amount),
      };
}
