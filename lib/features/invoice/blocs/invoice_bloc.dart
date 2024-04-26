import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/models/bank_account_dto.dart';

import '../../../commons/enums/enum_type.dart';
import '../../../commons/mixin/base_manager.dart';
import '../../../commons/utils/log.dart';
import '../../../models/invoice_fee_dto.dart';
import '../events/invoice_events.dart';
import '../repositories/invoice_repositories.dart';
import '../states/invoice_states.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceStates> with BaseManager {
  @override
  final BuildContext context;

  InvoiceBloc(this.context) : super(const InvoiceStates()) {
    on<InvoiceEvent>(_getListInvoice);
  }
  InvoiceRepository _invoiceRepository = InvoiceRepository();
  void _getListInvoice(InvoiceEvent event, Emitter emit) async {
    try {
      if (event is GetInvoiceList) {
        if (state.status == BlocStatus.NONE) {
          emit(state.copyWith(status: BlocStatus.LOADING));
        }

        List<InvoiceFeeDTO>? list = await _invoiceRepository.getInvoiceList(
          status: event.status,
          bankId: event.bankId,
          filterBy: event.filterBy,
          time: event.time,
          page: event.page,
          size: event.size,
        );
        if (list!.isNotEmpty) {
          emit(state.copyWith(
              metaDataDTO: _invoiceRepository.metaDataDTO,
              listInvoice: list,
              request: InvoiceType.GET_INVOICE_LIST,
              status: BlocStatus.SUCCESS));
        } else {
          emit(state.copyWith(
              listInvoice: [],
              request: InvoiceType.GET_INVOICE_LIST,
              status: BlocStatus.NONE));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR, msg: 'Đã có lỗi xảy ra.'));
    }
  }
}
