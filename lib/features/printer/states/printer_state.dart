import 'package:equatable/equatable.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:vierqr/models/bluetooth_printer_dto.dart';

class PrinterState extends Equatable {
  const PrinterState();

  @override
  List<Object?> get props => [];
}

class PrinterInitialState extends PrinterState {}

class PrinterLoadingState extends PrinterState {}

class PrinterScanningState extends PrinterState {}

class PrinterScanFailedState extends PrinterState {}

class PrinterReceiveSuccessState extends PrinterState {
  final PrinterBluetooth printer;
  const PrinterReceiveSuccessState({
    required this.printer,
  });

  @override
  List<Object?> get props => [printer];
}

class PrinterReceiveFailedState extends PrinterState {}

class PrinterSavingState extends PrinterState {}

class PrinterSavedSuccessState extends PrinterState {}

class PrinterSavedFailedState extends PrinterState {}

class PrinterCheckingState extends PrinterState {}

class PrinterCheckExistedState extends PrinterState {
  final BluetoothPrinterDTO dto;

  const PrinterCheckExistedState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class PrinterCheckNotExistedState extends PrinterState {}

class PrinterRemovingState extends PrinterState {}

class PrinterRemoveSuccessState extends PrinterState {}

class PrinterRemoveFailedState extends PrinterState {}
