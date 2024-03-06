import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/features/create_order_merchant/create_oder.dart';
import 'package:vierqr/features/create_order_merchant/respository/order_merchant_repository.dart';
import 'package:vierqr/features/merchant/tab_merchant/order_detail_view.dart';
import 'package:vierqr/models/invoice_dto.dart';

class TabOrderMerchant extends StatefulWidget {
  final String customerId;

  const TabOrderMerchant({super.key, required this.customerId});

  @override
  State<TabOrderMerchant> createState() => _TabOrderMerchantState();
}

class _TabOrderMerchantState extends State<TabOrderMerchant> {
  final orderRepository = OrderMerchantRepository();
  ScrollController controller = ScrollController();

  List<InvoiceDTO> list = [];
  List<InvoiceDTO> listPayment = [];
  List<InvoiceDTO> listUnpaid = [];
  bool isLoading = false;
  bool isLoadMore = true;
  int offset = 0;
  int limit = 20;

  @override
  void initState() {
    super.initState();
    _onGetListOrder();
    controller.addListener(_loadMore);
  }

  void _onGetListOrder(
      {bool loadMore = false,
      bool isLoading = true,
      bool isRefresh = false}) async {
    try {
      if (!isLoadMore) return;

      isLoading = isLoading;
      if (isRefresh) {
        isLoadMore = false;
      }
      updateState();

      final result =
          await orderRepository.getListOrder(widget.customerId, offset * limit);
      if (result.isEmpty || result.length < limit) {
        isLoadMore = false;
      } else {
        isLoadMore = true;
      }

      if (isLoadMore) {
        offset++;
      }

      isLoading = false;
      if (loadMore) {
        list = [...list, ...result];
      } else {
        list = [...result];
      }

      listPayment = list.where((element) => element.status == 1).toList();
      listUnpaid = list.where((element) => element.status == 0).toList();

      updateState();
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  void _loadMore() async {
    final maxScroll = controller.position.maxScrollExtent;
    if (controller.offset >= maxScroll && !controller.position.outOfRange) {
      _onGetListOrder(loadMore: true);
    }
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            controller: controller,
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildItemFeature(
                  'Dịch vụ',
                  des1: 'Tạo hoá đơn thanh toán',
                  des2:
                      'Hoá đơn có thể thanh toán từ các kênh giao dịch của BIDV.',
                  path: 'assets/images/ic-invoice-blue.png',
                  onTap: onCreateOrder,
                ),
                const SizedBox(height: 16),
                if (listUnpaid.isNotEmpty) ...[
                  Text('Chưa thanh toán', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 12),
                  ...List.generate(listUnpaid.length, (index) {
                    InvoiceDTO dto = list[index];
                    return _buildItem(dto);
                  })
                ],
                if (listPayment.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('Đã thanh toán', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 12),
                  ...List.generate(listPayment.length, (index) {
                    InvoiceDTO dto = list[index];
                    return _buildItem(dto, textColor: AppColor.GREEN);
                  })
                ],
                if (isLoadMore)
                  Center(
                    child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator()),
                  )
              ],
            ),
          ),
        ),
        Visibility(
          visible: isLoading,
          child: Positioned.fill(
            child: Container(
              color: AppColor.GREY_BG,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        )
      ],
    );
  }

  void onCreateOrder() async {
    await NavigatorUtils.navigatePage(
        context, CreateOrderScreen(customerId: widget.customerId),
        routeName: CreateOrderScreen.routeName);
    isLoadMore = true;
    offset = 0;
    updateState();
    _onGetListOrder();
  }

  Widget _buildItem(InvoiceDTO dto, {Color? textColor}) {
    return GestureDetector(
      onTap: () => _onDetailOrder(dto.billId ?? ''),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dto.name ?? '',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${CurrencyUtils.instance.getCurrencyFormatted('${dto.amount ?? 0}')} VND',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor ?? AppColor.ORANGE_DARK,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Ngày tạo: ',
                        style:
                            TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                      ),
                      Text(
                        dto.getTimeCreate,
                        style:
                            TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Image.asset('assets/images/ic-navigate-next-blue.png', width: 36)
          ],
        ),
      ),
    );
  }

  Widget _buildItemFeature(String title,
      {required String des1,
      required String des2,
      String path = '',
      Color? colorIcon,
      GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColor.WHITE,
            ),
            child: Row(
              children: [
                Image.asset(path, width: 30, color: colorIcon),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(des1,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 2),
                      Text(des2,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 12, color: AppColor.GREY_TEXT)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    isLoadMore = true;
    offset = 0;
    updateState();
    _onGetListOrder(isLoading: false, isRefresh: true);
  }

  void _onDetailOrder(String billId) async {
    final data = await NavigatorUtils.navigatePage(
        context, OrderDetailView(billId: billId),
        routeName: '');

    if (data != null && data is bool) {
      isLoadMore = true;
      offset = 0;
      updateState();
      _onGetListOrder(isRefresh: true);
    }
  }
}
