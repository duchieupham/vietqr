import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/create_order_merchant/respository/order_merchant_repository.dart';
import 'package:vierqr/features/create_order_merchant/views/input_order_second.dart';
import 'package:vierqr/features/create_store/responsitory/create_store_responsitory.dart';
import 'package:vierqr/layouts/m_button_widget.dart';

class InfoOrderView extends StatefulWidget {
  final List<OrderData> list;
  final String name;
  final String customerId;

  const InfoOrderView(
      {super.key,
      required this.list,
      required this.name,
      required this.customerId});

  @override
  State<InfoOrderView> createState() => _InfoOrderViewState();
}

class _InfoOrderViewState extends State<InfoOrderView> {
  CreateStoreRepository repository = CreateStoreRepository();
  OrderMerchantRepository orderRepository = OrderMerchantRepository();
  String _code = '';
  String _value = '';

  @override
  void initState() {
    super.initState();
    _onGetRandomCode();
  }

  _onCreateOrder() async {
    try {
      DialogWidget.instance.openLoadingDialog();

      Map<String, dynamic> body = {
        'name': widget.name,
        'customerId': widget.customerId,
        'items': List<dynamic>.from(widget.list.map((x) => x.toJson())),
      };

      final result = await orderRepository.createOrder(body);
      Navigator.pop(context);

      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: 'Tạo thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).hintColor,
          fontSize: 15,
        );
      }
    } catch (e) {
      Navigator.pop(context);
      LOG.error(e.toString());
    }
  }

  _onGetRandomCode() async {
    try {
      final result = await repository.getRandomCode();
      setState(() {
        _code = result;
      });
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  String total(List<OrderData> list) {
    int _total = 0;
    for (var e in list) {
      _total += int.parse(e.amount.isNotEmpty ? e.amount : '0');
    }

    _value = _total.toString();
    setState(() {});

    return CurrencyUtils.instance.getCurrencyFormatted(_value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thông tin hoá đơn của bạn\nđã chính xác chứ?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...[
                    _buildItem('Hoá đơn', widget.name),
                    _buildItem('Số tiền:', '${total(widget.list)} VND',
                        textColor: AppColor.ORANGE_DARK),
                    _buildItem('Mã hoá đơn', _code),
                    _buildItem('Ngày tạo',
                        DateFormat('HH:mm dd/MM/yyy').format(DateTime.now()),
                        isUnBorder: true),
                  ],
                  if (widget.list.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Danh mục hàng hoá, dịch vụ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        ...List.generate(
                          widget.list.length,
                          (index) {
                            OrderData dto = widget.list[index];
                            return _buildItemCategory(dto, index);
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          MButtonWidget(
            height: 50,
            title: 'Xác nhận',
            isEnable: true,
            margin: const EdgeInsets.symmetric(vertical: 10),
            onTap: _onCreateOrder,
          )
        ],
      ),
    );
  }

  Widget _buildItemCategory(OrderData dto, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0XFFFFFFFF), width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    (index + 1).toString() + '. ' + dto.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  CurrencyUtils.instance.getCurrencyFormatted(dto.price),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text('VND'),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Divider(
            color: Color(0xFFDADADA),
            height: 1,
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'x ${dto.quantity} = ',
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColor.GREY_TEXT,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  CurrencyUtils.instance.getCurrencyFormatted(dto.amount),
                  style: TextStyle(
                    color: AppColor.ORANGE_DARK,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text('VND'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title, String content,
      {bool isUnBorder = false, Color? textColor}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: isUnBorder
            ? null
            : Border(
                bottom: BorderSide(color: Color(0XFFDADADA), width: 1),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              content,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
