import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/create_order_merchant/create_oder.dart';
import 'package:vierqr/features/create_order_merchant/respository/order_merchant_repository.dart';
import 'package:vierqr/features/customer_va/repositories/customer_va_repository.dart';
import 'package:vierqr/features/customer_va/widgets/customer_va_invoice_success_widget.dart';
import 'package:vierqr/features/merchant/tab_merchant/order_detail_view.dart';
import 'package:vierqr/models/customer_va_invoice_success_dto.dart';
import 'package:vierqr/models/invoice_dto.dart';
import 'package:vierqr/models/vietqr_va_request_dto.dart';

import '../../customer_va/views/invoice_va_vietqr_view.dart';

class TabOrderMerchant extends StatefulWidget {
  final String customerId;

  const TabOrderMerchant({super.key, required this.customerId});

  @override
  State<TabOrderMerchant> createState() => _TabOrderMerchantState();
}

class _TabOrderMerchantState extends State<TabOrderMerchant> {
  final orderRepository = OrderMerchantRepository();
  final CustomerVaRepository customerVaRepository =
      const CustomerVaRepository();
  ScrollController controller = ScrollController();

  List<InvoiceDTO> list = [];
  List<InvoiceDTO> listPayment = [];
  List<InvoiceDTO> listUnpaid = [];
  List<ListType> listType = [
    ListType('Chưa thanh toán', 0),
    ListType('Đã thanh toán', 1),
  ];

  int selectType = 0;
  bool isLoading = false;
  bool isLoadMore = true;
  int offset = 0;
  int limit = 20;

  @override
  void initState() {
    super.initState();
    _onGetListOrder();
    // controller.addListener(_loadMore);
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  void _onGetListOrder(
      {bool loadMore = false,
      bool isLoading = true,
      bool isRefresh = false}) async {
    try {
      // if (!isLoadMore) return;

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
      if (isLoadMore) {
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
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
        controller: controller,
        physics: AlwaysScrollableScrollPhysics(),
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Danh sách hoá đơn',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,

            // width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                listType.length,
                (index) {
                  ListType tab = listType[index];
                  return Row(
                    children: [
                      _buildItemTab(tab, selectType == tab.type),
                      const SizedBox(width: 8)
                    ],
                  );
                },
              ),
            ),
          ),
          if (selectType == 0) ...[
            const SizedBox(height: 20),
            ...List.generate(listUnpaid.length, (index) {
              InvoiceDTO dto = listUnpaid[index];
              return _buildItem(dto);
            })
          ],
          if (selectType == 1) ...[
            const SizedBox(height: 20),
            ...List.generate(listPayment.length, (index) {
              InvoiceDTO dto = listPayment[index];
              return _buildItem(dto, textColor: AppColor.GREEN);
            })
          ],
          if (isLoadMore)
            Center(
              child: SizedBox(
                  width: 25, height: 25, child: CircularProgressIndicator()),
            )
        ],
      ),
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

  Widget _buildItemTab(ListType tab, bool select) {
    return InkWell(
      onTap: () {
        setState(() {
          selectType = tab.type;
          // isLoadMore = true;
        });
        _onGetListOrder();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color:
                select ? AppColor.BLUE_TEXT.withOpacity(0.2) : AppColor.WHITE,
            border: Border.all(
              color: select ? AppColor.WHITE : AppColor.GREY_DADADA,
            ),
            borderRadius: BorderRadius.circular(50)),
        child: Center(
          child: Text(tab.name,
              style: TextStyle(
                  color: select ? AppColor.BLUE_TEXT : AppColor.BLACK)),
        ),
      ),
    );
  }

  Widget _buildItem(InvoiceDTO dto, {Color? textColor}) {
    return InkWell(
      onTap: () => _onDetailOrder(dto.billId ?? ''),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        // margin: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      dto.name ?? '',
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColor.BLUE_TEXT,
                    size: 15,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      CurrencyUtils.instance.getCurrencyFormatted(
                            dto.amount.toString(),
                          ) +
                          ' VND',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: (dto.status == 0)
                            ? AppColor.ORANGE_DARK
                            : AppColor.GREEN,
                      ),
                    ),
                  ),
                  Text(
                    dto.getTimeCreate,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0XFF666A72),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const MySeparator(color: AppColor.GREY_DADADA),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColor.WHITE,
              border: Border.all(
                color: Color(0XFFDADADA),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(path, width: 40, color: colorIcon),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(des1,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 3),
                      Text(des2,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 13, color: AppColor.GREY_TEXT)),
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

class ListType {
  final String name;
  final int type;

  ListType(this.name, this.type);
}
