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
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: !isLoading
          ? ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                ...[
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Thông tin doanh nghiệp / tổ chức\nđã đăng ký dịch vụ thu hộ\nqua tài khoản định danh.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _buildItem('Doanh nghiệp:', merchantDTO?.merchantName ?? ''),
                  _buildItem('Mã doanh nghiệp:', merchantDTO?.merchantId ?? ''),
                  _buildItem('TK liên kết:', merchantDTO?.accountBank ?? ''),
                  _buildItem('CCCD/MST:', merchantDTO?.nationalId ?? ''),
                  _buildItem(
                      'SĐT xác thực:', merchantDTO?.phoneAuthenticated ?? '',
                      isUnBorder: true),
                  const SizedBox(height: 50),
                ],

                _buildItemFeature(
                  '',
                  des1: 'Huỷ đăng ký dịch vụ',
                  des2: 'Ngừng sử dụng dịch vụ thu hộ qua tài khoản định danh.',
                  path: 'assets/images/ic-remove-account.png',
                  colorIcon: AppColor.RED_EC1010,
                  onTap: onUnRegister,
                ),
                // Visibility(
                //   visible: isLoading,
                //   child: Positioned.fill(
                //     child: Container(
                //       color: AppColor.GREY_BG,
                //       child: Center(child: CircularProgressIndicator()),
                //     ),
                //   ),
                // )
              ],
            )
          : Positioned.fill(
              child: Container(
                color: AppColor.WHITE,
                child: const Center(child: CircularProgressIndicator()),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColor.WHITE,
              border: Border.all(
                color: const Color(0XFFDADADA),
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
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 3),
                      Text(des2,
                          maxLines: 2,
                          style: const TextStyle(
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

  Widget _buildItem(String title, String content, {bool isUnBorder = false}) {
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
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
