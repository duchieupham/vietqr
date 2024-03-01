import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/wallet_provider.dart';

import '../../scan_qr/widgets/qr_scan_widget.dart';

class CardWallet extends StatelessWidget {
  final Function startBarcodeScanStream;

  const CardWallet({Key? key, required this.startBarcodeScanStream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8)),
      child: ChangeNotifierProvider(
        create: (context) => WalletProvider(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoWallet(),
            const SizedBox(
              height: 12,
            ),
            _buildListAction(context),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
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
              return Consumer<WalletProvider>(
                  builder: (context, provider, child) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (provider.isHide)
                      const Text(
                        '********',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    else
                      Text(
                        '${CurrencyUtils.instance.getCurrencyFormatted(state.introduceDTO?.amount ?? '0')} VQR',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {
                        provider.updateHideAmount(!provider.isHide);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Image.asset(
                          provider.isHide
                              ? 'assets/images/ic-hide.png'
                              : 'assets/images/ic-unhide.png',
                          height: 15,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      state.introduceDTO?.point ?? '0',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Image.asset(
                      'assets/images/ic_point.png',
                      height: 18,
                    )
                  ],
                );
              });
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
          child:
              _buildItemAction('assets/images/ic-tb-card.png', 'Tài khoản', () {
            Navigator.pushNamed(context, Routes.SEARCH_BANK);
          }),
        ),
        Expanded(
          child: _buildItemAction('assets/images/ic-tb-qr.png', 'Quét QR',
              () async {
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
            'assets/images/ic-qr-wallet-grey.png',
            'Ví QR',
            () {
              eventBus.fire(ChangeBottomBarEvent(2));
            },
          ),
        ),
        Expanded(
          child: _buildItemAction(
            'assets/images/ic-history-transaction-wallet.png',
            'Lịch sử GD',
            () {
              Navigator.pushNamed(context, Routes.TRANSACTION_WALLET);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItemAction(String pathIcon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            pathIcon,
            height: 35,
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
}
