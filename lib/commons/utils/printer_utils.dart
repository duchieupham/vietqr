import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/models/bluetooth_printer_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/sqflite/local_database.dart';

class PrinterUtils {
  const PrinterUtils._privateConsrtructor();

  static const PrinterUtils _instance = PrinterUtils._privateConsrtructor();

  static PrinterUtils get instance => _instance;

  static PrinterBluetoothManager printerManager = PrinterBluetoothManager();

  Future<void> print(QRGeneratedDTO dto) async {
    try {
      String userId = SharePrefUtils.getProfile().userId;
      BluetoothPrinterDTO bluetoothPrinterDTO =
          await LocalDatabase.instance.getBluetoothPrinter(userId);
      late PrinterBluetooth? myPrinter;
      printerManager.scanResults.listen((printers) {
        if (printers.isNotEmpty) {
          for (PrinterBluetooth printer in printers) {
            if (printer.address == bluetoothPrinterDTO.address) {
              myPrinter = printer;
            }
          }
        }
      });

      printerManager.startScan(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 4), () async {
        if (myPrinter != null) {
          printerManager.selectPrinter(myPrinter!);
          const PaperSize paper = PaperSize.mm80;
          final profile = await CapabilityProfile.load();
          final Generator generator = Generator(paper, profile);
          List<int> bytes = [];
          bytes += generator.feed(3);
          // final ByteData data =
          //     await rootBundle.load('assets/images/ic-viet-qr.png');
          // final Uint8List buf = data.buffer.asUint8List();
          // final Image image = decodeImage(buf)!;
          // bytes += generator.image(image);
          bytes += generator.text(StringUtils.instance
              .removeDiacritic('Quét mã VietQR.vn để thanh toán'));
          bytes += generator.feed(1);
          bytes += generator.qrcode(dto.qrCode, size: const QRSize(500));
          bytes += generator.feed(3);
          if (dto.amount.trim().isNotEmpty && dto.amount.trim() != '0') {
            bytes += generator.text(
              '${dto.amount} VND',
              styles: const PosStyles(
                align: PosAlign.center,
                height: PosTextSize.size2,
                width: PosTextSize.size2,
              ),
            );
            bytes += generator.feed(1);
          }
          bytes += generator.text(StringUtils.instance
              .removeDiacritic('Tài khoản: ${dto.bankAccount}'));
          bytes += generator.text(StringUtils.instance
              .removeDiacritic('Chủ TK: ${dto.userBankName}'));
          bytes += generator.text(StringUtils.instance
              .removeDiacritic('Ngân hàng: ${dto.bankCode} - ${dto.bankName}'));
          if (dto.content.trim().isNotEmpty) {
            bytes += generator.text(StringUtils.instance
                .removeDiacritic('Nội dung: ${dto.content}'));
          }
          bytes += generator.feed(2);
          bytes += generator.cut();
          await printerManager.printTicket(bytes);
        }
      });
    } catch (e) {
      LOG.error(e.toString());
      // if (e.toString().contains('has not been initialized')) {
      //   await print(dto);
      // }
    }
  }

  Future<void> printQRCode(String qr) async {
    try {
      String userId = SharePrefUtils.getProfile().userId;
      BluetoothPrinterDTO bluetoothPrinterDTO =
          await LocalDatabase.instance.getBluetoothPrinter(userId);
      late PrinterBluetooth? myPrinter;
      printerManager.scanResults.listen((printers) {
        if (printers.isNotEmpty) {
          for (PrinterBluetooth printer in printers) {
            if (printer.address == bluetoothPrinterDTO.address) {
              myPrinter = printer;
            }
          }
        }
      });

      printerManager.startScan(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 4), () async {
        if (myPrinter != null) {
          printerManager.selectPrinter(myPrinter!);
          const PaperSize paper = PaperSize.mm80;
          final profile = await CapabilityProfile.load();
          final Generator generator = Generator(paper, profile);
          List<int> bytes = [];
          bytes += generator.feed(3);
          bytes += generator.text(StringUtils.instance
              .removeDiacritic('Quét mã VietQR.vn để thanh toán'));
          bytes += generator.feed(1);
          bytes += generator.qrcode(qr, size: const QRSize(500));
          bytes += generator.feed(2);
          bytes += generator.cut();
          await printerManager.printTicket(bytes);
        }
      });
    } catch (e) {}
  }
}
