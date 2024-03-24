import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/create_order_merchant/create_oder.dart';
import 'package:vierqr/features/create_order_merchant/respository/order_merchant_repository.dart';
import 'package:vierqr/features/merchant/responsitory/merchant_responsitory.dart';
import 'package:vierqr/models/invoice_dto.dart';
import 'package:vierqr/models/merchant_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class TabInfoMerchant extends StatefulWidget {
  final String customerId;
  final String bankId;

  const TabInfoMerchant({
    super.key,
    required this.customerId,
    required this.bankId,
  });

  @override
  State<TabInfoMerchant> createState() => _TabInfoMerchantState();
}

class _TabInfoMerchantState extends State<TabInfoMerchant> {
  final orderRepository = OrderMerchantRepository();
  final merchantRepository = MerchantRepository();
  List<InvoiceDTO> listUnpaid = [];
  MerchantDTO? merchantDTO;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _onGetListOrder();
    _getMerchant();
  }

  Future<void> _onRefresh() async {
    _onGetListOrder();
    _getMerchant(loading: false);
  }

  void _onGetListOrder() async {
    try {
      final result = await orderRepository.getListOrder(widget.customerId, 0);

      listUnpaid = result.where((element) => element.status == 0).toList();

      updateState();
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  void _getMerchant({bool loading = true}) async {
    try {
      isLoading = loading;
      updateState();
      final result = await bankCardRepository.getMerchantInfo(widget.bankId);
      isLoading = false;
      if (result != null) {
        if (result is MerchantDTO) {
          merchantDTO = result;
        } else {
          await DialogWidget.instance
              .openMsgDialog(title: 'Thông báo', msg: 'Đã có lỗi xảy ra');
        }
      }
      updateState();
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  void onUnRegister() async {
    try {
      DialogWidget.instance.openLoadingDialog();
      ResponseMessageDTO result = await merchantRepository.unRegisterMerchant(
          merchantDTO?.merchantId ?? '', SharePrefUtils.getProfile().userId);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        Navigator.pop(context);

        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          Navigator.pop(context, true);
          Fluttertoast.showToast(
            msg: 'Huỷ thành công',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
        }
      } else {
        Navigator.pop(context);
        await DialogWidget.instance
            .openMsgDialog(title: 'Thông báo', msg: 'Lỗi không xác định.');
      }
    } catch (e) {
      LOG.error(e.toString());
      Navigator.pop(context);
      await DialogWidget.instance
          .openMsgDialog(title: 'Thông báo', msg: 'Lỗi không xác định.');
    }
  }

  void onCreateOrder() {
    NavigatorUtils.navigatePage(
        context, CreateOrderScreen(customerId: widget.customerId),
        routeName: CreateOrderScreen.routeName);
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...[
                  _buildItem('Đại lý:', merchantDTO?.merchantName ?? ''),
                  _buildItem('Mã đại lý:', merchantDTO?.merchantId ?? ''),
                  _buildItem(
                      'Tài khoản ngân hàng:', merchantDTO?.accountBank ?? ''),
                  _buildItem('CCCD/MST:', merchantDTO?.nationalId ?? ''),
                  _buildItem('Số điện thoại xác thực:',
                      merchantDTO?.phoneAuthenticated ?? '',
                      isUnBorder: true),
                  const SizedBox(height: 24),
                ],
                if (listUnpaid.isEmpty)
                  _buildItemFeature(
                    'Dịch vụ',
                    des1: 'Tạo hoá đơn thanh toán',
                    des2:
                        'Hoá đơn có thể thanh toán từ các kênh giao dịch của BIDV.',
                    path: 'assets/images/ic-invoice-blue.png',
                    onTap: onCreateOrder,
                  ),
                const SizedBox(height: 16),
                _buildItemFeature(
                  'Cài đặt',
                  des1: 'Huỷ đăng ký đại lý',
                  des2: 'Ngừng sử dụng dịch vụ đại lý và quản lý hoá đơn.',
                  path: 'assets/images/ic-remove-account.png',
                  colorIcon: AppColor.RED_EC1010,
                  onTap: onUnRegister,
                ),
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

  Widget _buildItem(String title, String content, {bool isUnBorder = false}) {
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
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
