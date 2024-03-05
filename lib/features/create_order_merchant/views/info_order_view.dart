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
import 'package:vierqr/features/store/create_store/responsitory/create_store_responsitory.dart';
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Thông tin hoá đơn của bạn\nđã chính xác chưa?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
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
                        Text(
                          'Danh mục hàng hoá, dịch vụ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
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
            title: 'Xác nhận',
            isEnable: true,
            margin: EdgeInsets.zero,
            onTap: _onCreateOrder,
          )
        ],
      ),
    );
  }

  Widget _buildItemCategory(OrderData dto, int index) {
    return Container(
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
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
    );
  }

  Widget _buildItem(String title, String content,
      {bool isUnBorder = false, Color? textColor}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        border: isUnBorder
            ? null
            : Border(
                bottom: BorderSide(
                    color: AppColor.grey979797.withOpacity(0.3), width: 2),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, maxLines: 1),
          const SizedBox(height: 4),
          Text(
            content,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(fontSize: 18, color: textColor),
          ),
        ],
      ),
    );
  }
}
