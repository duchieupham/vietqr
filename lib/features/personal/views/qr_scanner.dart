import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/services/providers/suggestion_widget_provider.dart';

class QRScanner extends StatelessWidget {
  final String? title;
  static final MobileScannerController cameraController =
      MobileScannerController();

  const QRScanner({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          SubHeader(title: (title != null) ? title! : 'Quét mã QR'),
          Expanded(
            child: Consumer<SuggestionWidgetProvider>(
              builder: (context, provider, child) {
                return (provider.showCameraPermission)
                    ? const Center(
                        child: Text(
                          'Không thể quét QR. Vui lòng thử lại\nsau khi cho phép truy cập quyền máy ảnh.',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : MobileScanner(
                        controller: cameraController,
                        allowDuplicates: false,
                        onDetect: (barcode, args) {
                          final String code = barcode.rawValue ?? '';
                          if (code != '') {
                            Navigator.of(context).pop(code);
                          }
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
