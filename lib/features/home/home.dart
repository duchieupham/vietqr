import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/home/widget/card_wallet.dart';
import 'package:vierqr/features/home/widget/service_section.dart';

import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/services/providers/account_balance_home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  //focus node
  final FocusNode focusNode = FocusNode();

  //blocs

  NationalScannerDTO? identityDTO;

  //providers
  final AccountBalanceHomeProvider accountBalanceHomeProvider =
      AccountBalanceHomeProvider('');

  @override
  void initState() {
    super.initState();
  }

  void startBarcodeScanStream() async {
    final data = await Navigator.pushNamed(context, Routes.SCAN_QR_VIEW);
    if (data is Map<String, dynamic>) {
      if (!mounted) return;
      QRScannerUtils.instance.onScanNavi(
        data,
        context,
        onTapSave: (data) {
          context
              .read<DashBoardBloc>()
              .add(DashBoardEventAddContact(dto: data));
        },
        onTapAdd: (data) {
          context
              .read<DashBoardBloc>()
              .add(DashBoardCheckExistedEvent(dto: data['data']));
        },
      );
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                CardWallet(
                  startBarcodeScanStream: () {
                    startBarcodeScanStream();
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                const ServiceSection()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
