import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/models/vietqr_va_request_dto.dart';

class InvoiceVaVietQRView extends StatefulWidget {
  final VietQRVaRequestDTO dto;

  const InvoiceVaVietQRView({super.key, required this.dto});

  @override
  State<StatefulWidget> createState() => _InvoiceVaVietQRView();
}

class _InvoiceVaVietQRView extends State<InvoiceVaVietQRView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Mã VietQR thanh toán\nhoá đơn ${widget.dto.billId}',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close_rounded,
                  color: AppColor.BLACK,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
