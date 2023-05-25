import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:rxdart/subjects.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/bluetooth_printer_dto.dart';
import 'package:vierqr/services/sqflite/local_database.dart';

class PrinterRepository {
  static var printerController = BehaviorSubject<PrinterBluetooth>();
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();

  PrinterRepository();

  void stopScanPrinter() {
    printerManager.stopScan();
    PrinterRepository.printerController.close();
  }

  void scanPrinter() {
    try {
      printerManager.scanResults.listen((printers) {
        if (printers.isNotEmpty) {
          for (PrinterBluetooth printer in printers) {
            printerController.sink.add(printer);
          }
        }
      });
      printerManager.startScan(const Duration(seconds: 10));
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  Future<bool> savePrinter(BluetoothPrinterDTO dto) async {
    bool result = false;
    try {
      await LocalDatabase.instance
          .insertBluetoothPrinter(dto)
          .then((value) => result = true);
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<BluetoothPrinterDTO> getPrinterByUserId(String userId) async {
    BluetoothPrinterDTO result =
        const BluetoothPrinterDTO(id: '', name: '', address: '', userId: '');
    try {
      result = await LocalDatabase.instance.getBluetoothPrinter(userId);
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<bool> removePrinter(String userId) async {
    bool result = false;
    try {
      await LocalDatabase.instance
          .deleteBluetoothPrinter(userId)
          .then((value) => result = true);
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
