// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:vierqr/features/qr_wallet/widgets/default_appbar_widget.dart';

enum TypeQr {
  VIETQR,
  QR_LINK,
  VCARD,
  OTHER,
}

class QrLinkScreen extends StatefulWidget {
  final TypeQr type;
  const QrLinkScreen({super.key, required this.type});

  @override
  State<QrLinkScreen> createState() => _QrLinkScreenState();
}

class _QrLinkScreenState extends State<QrLinkScreen> {
  TypeQr? _qrType;

  @override
  void initState() {
    super.initState();
    _qrType = widget.type;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const DefaultAppbarWidget(),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // child: _buildBody(),
            ),
          )
        ],
      ),
    );
  }
}
