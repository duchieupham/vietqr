import 'package:flutter/material.dart';
import 'package:vierqr/layouts/m_app_bar.dart';

import 'views/info_order_view.dart';
import 'views/input_name_order.dart';
import 'views/input_order_second.dart';

class CreateOrderScreen extends StatefulWidget {
  static String routeName = '/CreateOrderScreen';

  final String customerId;

  const CreateOrderScreen({super.key, required this.customerId});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  int step = 1;
  String orderName = '';
  List<OrderData> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
        title: 'Tạo hoá đơn',
        onPressed: _handleBack,
      ),
      body: Column(
        children: [
          Expanded(child: _buildStep()),
        ],
      ),
    );
  }

  Widget _buildStep() {
    if (step == 1) {
      return InputNameOrderView(
        orderName: orderName,
        callBack: (value) {
          step = 2;
          orderName = value;
          setState(() {});
        },
      );
    } else if (step == 2) {
      return InputOrderSecondView(
        listOrder: list,
        callBack: (data) {
          list = [...data];
          step = 3;
          setState(() {});
        },
        orderName: '',
      );
    }

    return InfoOrderView(
      list: list,
      name: orderName,
      customerId: widget.customerId,
    );
  }

  void _handleBack() {
    switch (step) {
      case 1:
        Navigator.pop(context);
        break;
      case 2:
        step = 1;
        list = [];
        setState(() {});
        break;
      case 3:
        step = 2;
        setState(() {});
        break;
    }
  }
}
