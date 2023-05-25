import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/printer/events/printer_event.dart';
import 'package:vierqr/features/printer/repositories/printer_repository.dart';
import 'package:vierqr/features/printer/states/printer_state.dart';
import 'package:vierqr/models/bluetooth_printer_dto.dart';
import 'package:rxdart/subjects.dart';

class PrinterBloc extends Bloc<PrinterEvent, PrinterState> {
  PrinterBloc() : super(PrinterInitialState()) {
    on<PrinterInitialEvent>(_initial);
    on<PrinterEventScan>(_scanPrinter);
    on<PrinterEventReceive>(_receivePrinter);
    on<PrinterEventSave>(_savePrinter);
    on<PrinterEventCheck>(_checkPrinter);
    on<PrinterEventRemove>(_removePrinter);
  }
}

PrinterRepository _printerRepository = PrinterRepository();

void _initial(PrinterEvent event, Emitter emit) {
  emit(PrinterInitialState());
}

void _scanPrinter(PrinterEvent event, Emitter emit) async {
  try {
    if (event is PrinterEventScan) {
      emit(PrinterScanningState());
      if (PrinterRepository.printerController.isClosed) {
        PrinterRepository.printerController =
            BehaviorSubject<PrinterBluetooth>();
      }
      _printerRepository.scanPrinter();
      PrinterRepository.printerController.listen((printer) {
        if (printer.address != null && printer.address!.isNotEmpty) {
          event.printerBloc.add(PrinterEventReceive(printer: printer));
        }
      });
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(PrinterScanFailedState());
  }
}

void _receivePrinter(PrinterEvent event, Emitter emit) async {
  try {
    if (event is PrinterEventReceive) {
      emit(PrinterReceiveSuccessState(printer: event.printer));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(PrinterReceiveFailedState());
  }
}

void _savePrinter(PrinterEvent event, Emitter emit) async {
  try {
    if (event is PrinterEventSave) {
      emit(PrinterSavingState());
      _printerRepository.stopScanPrinter();
      final check = await _printerRepository.savePrinter(event.printer);
      if (check) {
        emit(PrinterSavedSuccessState());
      } else {
        emit(PrinterSavedFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(PrinterSavedFailedState());
  }
}

void _removePrinter(PrinterEvent event, Emitter emit) async {
  try {
    if (event is PrinterEventRemove) {
      emit(PrinterRemovingState());
      _printerRepository.stopScanPrinter();
      bool check = await _printerRepository.removePrinter(event.userId);
      if (check) {
        emit(PrinterRemoveSuccessState());
      } else {
        emit(PrinterRemoveFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(PrinterRemoveFailedState());
  }
}

void _checkPrinter(PrinterEvent event, Emitter emit) async {
  try {
    if (event is PrinterEventCheck) {
      emit(PrinterCheckingState());
      BluetoothPrinterDTO dto =
          await _printerRepository.getPrinterByUserId(event.userId);
      if (dto.id.isNotEmpty) {
        emit(PrinterCheckExistedState(dto: dto));
      } else {
        emit(PrinterCheckNotExistedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(PrinterCheckNotExistedState());
  }
}
