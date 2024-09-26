import 'package:equatable/equatable.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:vierqr/features/printer/blocs/printer_bloc.dart';
import 'package:vierqr/models/bluetooth_printer_dto.dart';

class PrinterEvent extends Equatable {
  const PrinterEvent();

  @override
  List<Object?> get props => [];
}

class PrinterInitialEvent extends PrinterEvent {}

class PrinterEventCheckPairing extends PrinterEvent {}

class PrinterEventScan extends PrinterEvent {
  final PrinterBloc printerBloc;

  const PrinterEventScan({
    required this.printerBloc,
  });

  @override
  List<Object?> get props => [printerBloc];
}

class PrinterEventReceive extends PrinterEvent {
  final PrinterBluetooth printer;

  const PrinterEventReceive({
    required this.printer,
  });

  @override
  List<Object?> get props => [printer];
}

class PrinterEventSave extends PrinterEvent {
  final BluetoothPrinterDTO printer;

  const PrinterEventSave({
    required this.printer,
  });

  @override
  List<Object?> get props => [printer];
}

class PrinterEventCheck extends PrinterEvent {
  final String userId;

  const PrinterEventCheck({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}

class PrinterEventRemove extends PrinterEvent {
  final String userId;

  const PrinterEventRemove({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}
