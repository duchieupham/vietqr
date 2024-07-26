import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/create_order_merchant/respository/order_merchant_repository.dart';
import 'package:vierqr/features/customer_va/views/invoice_va_vietqr_view.dart';
import 'package:vierqr/features/customer_va/widgets/customer_va_header_widget.dart';
import 'package:vierqr/models/invoice_dto.dart';
import 'package:vierqr/models/vietqr_va_request_dto.dart';

class OrderDetailView extends StatefulWidget {
  final String billId;

  const OrderDetailView({super.key, required this.billId});

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  final orderRepository = const OrderMerchantRepository();
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
      appBar: const CustomerVaHeaderWidget(),
      backgroundColor: AppColor.WHITE,
      bottomNavigationBar: _bottom(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      dto.name ?? '',
                      style: const TextStyle(
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
                      const Text(
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
                    ],
                    // if (dto.status == 0)

                    const SizedBox(height: 16),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _bottom() {
    return dto.status == 0
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColor.BLUE_TEXT,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: InkWell(
                      onTap: () {
                        print(dto.toJson());
                        VietQRVaRequestDTO requestVietQRDTO =
                            VietQRVaRequestDTO(
                                billId: dto.billId ?? '',
                                userBankName: dto.userBankName ?? '',
                                amount: dto.amount.toString(),
                                description: dto.billId ?? '');
                        // _generateVietQRVa(requestVietQRDTO);
                        DialogWidget.instance.showModelBottomSheet(
                          widget: InvoiceVaVietQRView(
                            vietQRVaRequestDTO: requestVietQRDTO,
                            invoiceDTO: dto,
                          ),
                          height: MediaQuery.of(context).size.height * 0.9,
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_rounded,
                            size: 15,
                            color: AppColor.WHITE,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'QR thanh toán',
                            style: TextStyle(color: AppColor.WHITE),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColor.RED_EC1010.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: InkWell(
                    onTap: _removeOrder,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/ic-remove-account.png',
                          width: 30,
                          color: AppColor.RED_EC1010,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Huỷ TT',
                          style: TextStyle(color: AppColor.RED_EC1010),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildItemCategory(Item dto, int index, {bool isSuccess = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0XFFFFFFFF), width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${index + 1}. ${dto.name ?? ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
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
                const Text('VND'),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
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
                    style: const TextStyle(
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
                const Text('VND'),
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
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: isUnBorder
            ? null
            : const Border(
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
