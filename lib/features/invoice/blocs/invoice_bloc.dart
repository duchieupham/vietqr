import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../commons/mixin/base_manager.dart';
import '../events/invoice_events.dart';
import '../states/invoice_states.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceStates> with BaseManager {
  @override
  final BuildContext context;

  InvoiceBloc(this.context) : super(const InvoiceStates()) {
    on<InvoiceEvent>(_getListInvoice);
  }

  void _getListInvoice(InvoiceEvent event, Emitter emit) {}
}
