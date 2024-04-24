import 'package:flutter/material.dart';

import '../../models/qr_generated_dto.dart';

class HomeScreenVietQrWidget extends StatefulWidget {
  final QRGeneratedDTO? qrGeneratedDTO;

  const HomeScreenVietQrWidget({super.key, this.qrGeneratedDTO});

  @override
  State<HomeScreenVietQrWidget> createState() => _HomeScreenVietQrWidgetState();
}

class _HomeScreenVietQrWidgetState extends State<HomeScreenVietQrWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
