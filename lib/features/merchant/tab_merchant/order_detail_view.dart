import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/create_order_merchant/respository/order_merchant_repository.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/invoice_dto.dart';

class OrderDetailView extends StatefulWidget {
  final String billId;

  const OrderDetailView({super.key, required this.billId});

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  final orderRepository = OrderMerchantRepository();
  bool isLoading = true;
  InvoiceDTO dto = InvoiceDTO();

  @override
  void initState() {
    super.initState();
    _onGetDetail();
  }

  void _onGetDetail() async {
    try {
      final result = await orderRepository.getDetailOrder(widget.billId);
      isLoading = false;
      dto = result;
      updateState();
    } catch (e) {
      isLoading = false;
      updateState();
    }
  }

  void _removeOrder() async {
    try {
      DialogWidget.instance.openLoadingDialog();

      final result = await orderRepository.removeOrder(widget.billId);
      Navigator.pop(context);

      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        Navigator.pop(context, true);
        Fluttertoast.showToast(
          msg: 'Xoá thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).hintColor,
          fontSize: 15,
        );
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(title: 'Hoá đơn'),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        dto.name ?? '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ...[
                        const SizedBox(height: 24),
                        _buildItem('Số tiền',
                            '${CurrencyUtils.instance.getCurrencyFormatted('${dto.amount ?? 0}')} VND',
                            textColor: AppColor.ORANGE_DARK),
                        _buildItem('Trạng thái:', dto.getStatus,
                            textColor: dto.status == 0
                                ? AppColor.ORANGE_DARK
                                : AppColor.GREEN),
                        _buildItem('Mã hoá đơn', dto.billId ?? ''),
                        _buildItem('Ngày tạo', dto.getTimeCreate,
                            isUnBorder: true),
                      ],
                      if (dto.items != null && dto.items!.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Danh mục hàng hoá, dịch vụ',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(
                          dto.items!.length,
                          (index) {
                            Item item = dto.items![index];
                            return _buildItemCategory(item, index);
                          },
                        ),
                      ]
                    ],
                  ),
                ),
              ),
              if (dto.status == 0)
                MButtonWidget(
                  title: 'Huỷ hoá đơn thanh toán',
                  isEnable: true,
                  colorEnableBgr: AppColor.RED_EC1010.withOpacity(0.2),
                  height: 50,
                  onTap: _removeOrder,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/ic-remove-account.png',
                        width: 30,
                        color: AppColor.RED_EC1010,
                      ),
                      const SizedBox(width: 24),
                      Text(
                        'Huỷ hoá đơn thanh toán',
                        style: TextStyle(color: AppColor.RED_EC1010),
                      )
                    ],
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
          Visibility(
            visible: isLoading,
            child: Positioned.fill(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemCategory(Item dto, int index) {
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
                    dto.name ?? '',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    dto.description ?? '',
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
                  '${dto.quantity ?? 0}',
                  style: TextStyle(color: AppColor.ORANGE_DARK),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Đơn giá:${CurrencyUtils.instance.getCurrencyFormatted('${dto.amount}')} VND',
                style: TextStyle(color: AppColor.GREY_TEXT),
              ),
              const Spacer(),
              Text(
                ' ${CurrencyUtils.instance.getCurrencyFormatted('${dto.totalAmount}')} VND',
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
