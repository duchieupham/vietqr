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
import 'package:flutter_svg/flutter_svg.dart';
import '../../scan_qr/widgets/qr_scan_widget.dart';

class CardWallet extends StatelessWidget {
  final Function startBarcodeScanStream;

  const CardWallet({Key? key, required this.startBarcodeScanStream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WalletProvider(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: AppColor.TRANSPARENT,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(18),
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5))),
                  child: Consumer<AuthProvider>(
                    builder: (context, state, child) {
                      return Consumer<WalletProvider>(
                        builder: (context, provider, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Số dư:',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColor.GREY_TEXT),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          provider.updateHideAmount(
                                              !provider.isHide);
                                        },
                                        child: Image.asset(
                                          provider.isHide
                                              ? 'assets/images/ic-hide.png'
                                              : 'assets/images/ic-unhide.png',
                                          height: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Điểm thưởng:',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColor.GREY_TEXT),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        state.introduceDTO?.point ?? '0',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Image.asset(
                                        'assets/images/ic_point.png',
                                        height: 18,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 20, right: 20),
              color: AppColor.TRANSPARENT,
              child: Stack(
                children: [
                  Container(
                    // alignment: Alignment.bottomCenter,
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Shadow color
                          spreadRadius:
                              -2, // Extent of the shadow in all directions
                          blurRadius: 10, // How much to blur the shadow
                          offset: Offset(0,
                              1), // Horizontal and vertical offset of the shadow
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColor.WHITE,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Shadow color
                            spreadRadius:
                                -2, // Extent of the shadow in all directions
                            blurRadius: 10, // How much to blur the shadow
                            offset: Offset(0,
                                1), // Horizontal and vertical offset of the shadow
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildItemAction(
                                'assets/images/ic-tb-card-black.png',
                                'Tài khoản', () {
                              Navigator.pushNamed(context, Routes.SEARCH_BANK);
                            }),
                          ),
                          Expanded(
                            child: _buildItemAction(
                              'assets/images/ic-invoice-black.png',
                              'Hóa đơn',
                              () {
                                Navigator.pushNamed(
                                    context, Routes.INVOICE_SCREEN);

                                // eventBus.fire(ChangeBottomBarEvent(2));
                              },
                            ),
                          ),
                          Expanded(
                            child: _buildItemAction(
                                'assets/images/ic-tb-qr.png', 'Quét QR',
                                () async {
                              if (SharePrefUtils.getQrIntro()) {
                                startBarcodeScanStream();
                              } else {
                                await DialogWidget.instance
                                    .showFullModalBottomContent(
                                  widget: const QRScanWidget(),
                                  color: AppColor.BLACK,
                                );
                                startBarcodeScanStream();
                              }
                            }),
                          ),
                          Expanded(
                            child: _buildItemAction(
                              'assets/images/ic-history-transaction-wallet.png',
                              'Lịch sử GD',
                              () {
                                Navigator.pushNamed(
                                    context, Routes.TRANSACTION_WALLET);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemAction(String pathIcon, String title, VoidCallback onTap,
      {bool isSvg = false}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isSvg == false
                ? Image.asset(
                    pathIcon,
                    height: 25,
                    width: 25,
                  )
                : SvgPicture.asset(
                    pathIcon,
                    height: 35,
                    // color: AppColor.BLACK,
                  ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            )
          ],
        ),
      ),
    );
  }
}
