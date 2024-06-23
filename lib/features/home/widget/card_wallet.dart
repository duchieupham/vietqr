import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import '../../scan_qr/widgets/qr_scan_widget.dart';

class CardWallet extends StatefulWidget {
  const CardWallet({super.key});

  @override
  State<CardWallet> createState() => _CardWalletState();
}

class _CardWalletState extends State<CardWallet> {
  final ValueNotifier<bool> isHide = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildInfoWallet(),
          const SizedBox(height: 12),
          _buildListAction(context),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildInfoWallet() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text('Số dư: ',
            style: TextStyle(color: AppColor.GREY_TEXT, fontSize: 13)),
        Expanded(
          child: Consumer<AuthProvider>(
            builder: (context, state, child) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: isHide,
                    builder: (context, value, child) {
                      if (value) {
                        return const Text(
                          '********',
                          style: TextStyle(fontSize: 16),
                        );
                      }
                      return Text(
                        '${CurrencyUtils.instance.getCurrencyFormatted(state.introduceDTO?.amount ?? '0')} VQR',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      isHide.value = !isHide.value;
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: ValueListenableBuilder<bool>(
                          valueListenable: isHide,
                          builder: (context, value, child) {
                            return XImage(
                              imagePath: value
                                  ? ImageConstant.icHide
                                  : ImageConstant.icUnHide,
                              height: 15,
                            );
                          }),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    state.introduceDTO?.point ?? '0',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const XImage(
                    imagePath: ImageConstant.icPoint,
                    height: 18,
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListAction(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildItemAction(ImageConstant.icBankAccountHome, 'Tài khoản',
              () {
            Navigator.pushNamed(context, Routes.SEARCH_BANK);
          }),
        ),
        Expanded(
          child: _buildItemAction(
            ImageConstant.icInvoiceHome,
            'Hoá đơn',
            () {
              Navigator.of(context).pushNamed(Routes.INVOICE_SCREEN);
              // Navigator.of(context).pushNamed(Routes.INVOICE_DETAIL,arguments: {
              //     'id' : '345310c1-470b-4663-846b-7d1555b037b1'
              // });
            },
          ),
        ),
        Expanded(
          child:
              _buildItemAction(ImageConstant.icScanQrHome, 'Quét QR', () async {
            if (SharePrefUtils.getQrIntro()) {
              startBarcodeScanStream();
            } else {
              await DialogWidget.instance.showFullModalBottomContent(
                widget: const QRScanWidget(),
                color: AppColor.BLACK,
              );
              startBarcodeScanStream();
            }
          }),
        ),
        Expanded(
          child: _buildItemAction(
            ImageConstant.icApplicationHome,
            'Khám phá\nsản phẩm',
            () {
              // Navigator.pushNamed(context, Routes.TRANSACTION_WALLET);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItemAction(String pathIcon, String title, VoidCallback onTap,
      {Color? color = null}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            pathIcon,
            height: 35,
            color: color,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
          )
        ],
      ),
    );
  }

  void startBarcodeScanStream() async {
    final data = await Navigator.pushNamed(context, Routes.SCAN_QR_VIEW);
    if (data is Map<String, dynamic>) {
      if (!mounted) return;
      QRScannerUtils.instance.onScanNavi(data, context);
    }
  }
}
