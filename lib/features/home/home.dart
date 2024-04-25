import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/home/widget/assistance_widget.dart';
import 'package:vierqr/features/home/widget/card_wallet.dart';
import 'package:vierqr/features/home/widget/service_section.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import '../../commons/utils/currency_utils.dart';
import '../../models/user_profile.dart';
import '../../services/providers/wallet_provider.dart';
import '../bank_detail/blocs/detail_group_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  UserProfile? profile;

  @override
  void initState() {
    super.initState();
    profile = SharePrefUtils.getProfile();
  }

  void startBarcodeScanStream() async {
    final data = await Navigator.pushNamed(context, Routes.SCAN_QR_VIEW);
    if (data is Map<String, dynamic>) {
      if (!mounted) return;
      QRScannerUtils.instance.onScanNavi(data, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async {
          eventBus.fire(ReloadWallet());
        },
        child: SizedBox(
          width: width,
          height: height,
          child: ListView(
            // padding: const EdgeInsets.only(top: 10),
            children: [
              CardWallet(
                startBarcodeScanStream: () {
                  startBarcodeScanStream();
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                // color: AppColor.WHITE,
                height: height,
                child: Column(
                  children: [
                    AssistanceInfo(
                        isUpdateInfo: profile?.firstName == 'Undefined'),
                    const SizedBox(
                      height: 30,
                    ),
                    const ServiceSection()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
