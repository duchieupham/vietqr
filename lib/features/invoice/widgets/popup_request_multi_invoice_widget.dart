import 'package:flutter/material.dart';
import 'package:vierqr/models/unpaid_invoice_detail_qr_dto.dart';

class PopupRequestMultiInvoiceWidget extends StatefulWidget {
  final UnpaidInvoiceDetailQrDTO dto;
  const PopupRequestMultiInvoiceWidget({super.key, required this.dto});

  @override
  State<PopupRequestMultiInvoiceWidget> createState() =>
      _PopupRequestMultiInvoiceWidgetState();
}

class _PopupRequestMultiInvoiceWidgetState
    extends State<PopupRequestMultiInvoiceWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
