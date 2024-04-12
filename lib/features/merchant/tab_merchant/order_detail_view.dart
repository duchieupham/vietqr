import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/create_order_merchant/respository/order_merchant_repository.dart';
import 'package:vierqr/features/customer_va/widgets/customer_va_header_widget.dart';
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

  void _onGetDetail({bool loading = true}) async {
    try {
      isLoading = loading;
      updateState();
      final result = await orderRepository.getDetailOrder(widget.billId);
      isLoading = false;
      dto = result;
      updateState();
    } catch (e) {
      isLoading = false;
      updateState();
    }
  }

  Future<void> _onRefresh() async {
    _onGetDetail(loading: false);
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
      appBar: CustomerVaHeaderWidget(),
      backgroundColor: AppColor.WHITE,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
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
                          const SizedBox(height: 10),
                          _buildItem(
                            'Số tiền',
                            '${CurrencyUtils.instance.getCurrencyFormatted('${dto.amount ?? 0}')} VND',
                            textColor: dto.status == 0
                                ? AppColor.ORANGE_DARK
                                : AppColor.GREEN,
                            textSized: 20,
                          ),
                          _buildItem('Trạng thái:', dto.getStatus,
                              textColor: dto.status == 0
                                  ? AppColor.ORANGE_DARK
                                  : AppColor.GREEN),
                          _buildItem('Mã hoá đơn', dto.billId ?? ''),
                          _buildItem('Ngày tạo', dto.getTimeCreate,
                              isUnBorder: true),
                        ],
                        if (dto.items != null && dto.items!.isNotEmpty) ...[
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
                            dto.items!.length,
                            (index) {
                              Item item = dto.items![index];
                              return _buildItemCategory(item, index,
                                  isSuccess: dto.status == 1);
                            },
                          ),
                        ]
                      ],
                    ),
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

  Widget _buildItemCategory(Item dto, int index, {bool isSuccess = false}) {
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
                    (index + 1).toString() + '. ' + (dto.name ?? ''),
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
                  CurrencyUtils.instance
                      .getCurrencyFormatted(dto.amount.toString()),
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
                  CurrencyUtils.instance
                      .getCurrencyFormatted(dto.amount.toString()),
                  style: TextStyle(
                    color: (isSuccess) ? AppColor.GREEN : AppColor.ORANGE_DARK,
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
      {bool isUnBorder = false, Color? textColor, double? textSized}) {
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
                fontSize: textSized ?? 13,
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
