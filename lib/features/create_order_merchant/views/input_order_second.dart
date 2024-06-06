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
                  'Tiếp theo, vui lòng nhập\ncác danh mục hàng hoá, dịch vụ\ncủa hoá đơn.',
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
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _onAddCategory,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      // border: Border.all(
                      //     color: AppColor.GREY_TEXT.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(5),
                      color: AppColor.BLUE_TEXT.withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/ic-invoice-blue.png',
                            width: 30),
                        const SizedBox(width: 10),
                        Text(
                          'Thêm mới danh mục',
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
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: AppColor.WHITE,
                border: Border(
                  top: BorderSide(color: Color(0xFFDADADA), width: 1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      // height: 40,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                      fontSize: 20),
                                ),
                                TextSpan(
                                  text: ' VND',
                                  style: TextStyle(
                                      color: AppColor.BLACK, fontSize: 20),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  MButtonWidget(
                    title: 'Tiếp tục',
                    height: 40,
                    isEnable: list.isNotEmpty,
                    colorDisableBgr: AppColor.GREY_VIEW,
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    margin: const EdgeInsets.all(0),
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
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFDADADA),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Danh mục:',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              Text(
                dto.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                dto.des,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                color: Color(0XFFDADADA),
              ),
              SizedBox(
                height: 35,
                child: Row(
                  children: [
                    Text('Đơn giá:'),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        CurrencyUtils.instance.getCurrencyFormatted(dto.price),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text('VND')
                  ],
                ),
              ),
              Divider(
                color: Color(0XFFDADADA),
              ),
              SizedBox(
                height: 35,
                child: Row(
                  children: [
                    Text('Số lượng:'),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        dto.quantity,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Color(0XFFDADADA),
              ),
              SizedBox(
                height: 35,
                child: Row(
                  children: [
                    Text('Thành tiền:'),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        CurrencyUtils.instance.getCurrencyFormatted(dto.amount),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColor.ORANGE_DARK,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text('VND')
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                list.removeAt(index);
              });
            },
            child: Image.asset(
              'assets/images/ic-remove-account.png',
              width: 50,
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
        "amount": int.parse(price),
      };
}
