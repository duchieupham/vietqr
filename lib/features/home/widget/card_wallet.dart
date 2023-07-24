import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/account/blocs/account_bloc.dart';
import 'package:vierqr/features/account/states/account_state.dart';
import 'package:vierqr/services/providers/wallet_provider.dart';
import 'package:vierqr/services/shared_references/qr_scanner_helper.dart';

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
          child: BlocConsumer<AccountBloc, AccountState>(
              listener: (context, state) {},
              builder: (context, state) {
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
                          '${CurrencyUtils.instance.getCurrencyFormatted(state.introduceDTO!.amount ?? '0')} VND',
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
                        child: Image.asset(
                          provider.isHide
                              ? 'assets/images/ic-unhide.png'
                              : 'assets/images/ic-hide.png',
                          height: 18,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        state.introduceDTO!.point ?? '0',
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
              }),
        ),
      ],
    );
  }

  Widget _buildListAction(BuildContext context) {
    return Row(
      children: [
        _buildItemAction('assets/images/ic-tb-card.png', 'Tài khoản', () {
          Navigator.pushNamed(context, Routes.SEARCH_BANK);
        }),
        const Spacer(),
        _buildItemAction('assets/images/ic-money-add.png', 'Nạp tiền', () {
          DialogWidget.instance.openMsgDialog(
            title: 'Tính năng đang bảo trì',
            msg: 'Vui lòng thử lại sau',
          );
        }),
        const Spacer(),
        _buildItemAction('assets/images/ic-tb-qr.png', 'Quét QR', () async {
          if (QRScannerHelper.instance.getQrIntro()) {
            startBarcodeScanStream();
          } else {
            await DialogWidget.instance.showFullModalBottomContent(
              widget: const QRScanWidget(),
              color: AppColor.BLACK,
            );
            startBarcodeScanStream();
          }
        }),
        const Spacer(),
        _buildItemAction(
          'assets/images/ic-contact.png',
          'Danh bạ',
          () {
            Navigator.pushNamed(context, Routes.PHONE_BOOK);
          },
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
            height: 38,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
