import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/home/widget/card_wallet.dart';
import 'package:vierqr/features/home/widget/service_section.dart';

import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/services/providers/account_balance_home_provider.dart';

import 'blocs/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  //focus node
  final FocusNode focusNode = FocusNode();

  //blocs
  late HomeBloc _homeBloc;

  NationalScannerDTO? identityDTO;

  //providers
  final AccountBalanceHomeProvider accountBalanceHomeProvider =
      AccountBalanceHomeProvider('');

  @override
  void initState() {
    super.initState();
    _homeBloc = BlocProvider.of(context);
  }

  Future<void> startBarcodeScanStream(BuildContext context) async {
    String data = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.QR);
    if (data.isNotEmpty) {
      if (data == TypeQR.NEGATIVE_ONE.value) {
      } else if (data == TypeQR.NEGATIVE_TWO.value) {
        DialogWidget.instance.openMsgDialog(
          title: 'Không thể xác nhận mã QR',
          msg: 'Ảnh QR không đúng định dạng, vui lòng chọn ảnh khác.',
          function: () {
            Navigator.pop(context);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        );
      } else {
        if (data.contains('|')) {
          final list = data.split("|");
          if (list.isNotEmpty) {
            NationalScannerDTO identityDTO = NationalScannerDTO.fromJson(list);
            if (!mounted) return;
            Navigator.pushNamed(
              context,
              Routes.NATIONAL_INFORMATION,
              arguments: {'dto': identityDTO},
            );
          }
        } else {
          if (!mounted) return;
          // _bloc.add(ScanQrEventGetBankType(code: data));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              CardWallet(
                startBarcodeScanStream: () {
                  startBarcodeScanStream(context);
                },
              ),
              const SizedBox(
                height: 24,
              ),
              const ServiceSection()
            ],
          ),
        ),
      ),
    );
  }
}
