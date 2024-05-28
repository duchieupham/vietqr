import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/features/qr_box/events/qr_box_event.dart';
import 'package:vierqr/features/qr_box/repositories/qr_box_repository.dart';
import 'package:vierqr/features/qr_box/states/qr_box_state.dart';

class QRBoxBloc extends Bloc<QRBoxEvent, QRBoxState> with BaseManager {
  final BuildContext context;

  QRBoxBloc(this.context) : super(QRBoxState()) {}

  QRBoxRepository _repository = QRBoxRepository();
}
