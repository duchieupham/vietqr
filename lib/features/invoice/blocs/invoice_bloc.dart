import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/models/invoice_detail_dto.dart';

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

  List<InvoiceFeeDTO> listInvoice = [];

  InvoiceBloc(this.context) : super(const InvoiceStates()) {
    on<InvoiceEvent>(_getListInvoice);
    on<GetInvoiceDetail>(_getDetailInvoice);
    on<GetInvoiceList>(_getListInvoice);
    on<LoadMoreInvoice>(_loadMoreInvoice);
  }
  final InvoiceRepository _invoiceRepository = InvoiceRepository();

  Future<InvoiceDetailDTO?> getDetail(String id) async {
    try {
      final result = await _invoiceRepository.getInvoiceDetail(invoiceId: id);
      if (result != null) {
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }

  void _getDetailInvoice(
    InvoiceEvent event,
    Emitter emit,
  ) async {
    try {
      if (event is GetInvoiceDetail) {
        if (state.status == BlocStatus.NONE) {
          emit(state.copyWith(status: BlocStatus.LOADING));
        }

        final result = await _invoiceRepository.getInvoiceDetail(
            invoiceId: event.invoiceId);
        if (result != null) {
          emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              invoiceDetailDTO: result,
              request: InvoiceType.INVOICE_DETAIL));
          // callback(result);
        } else {
          emit(state.copyWith(
              invoiceDetailDTO: null,
              request: InvoiceType.INVOICE_DETAIL,
              status: BlocStatus.NONE));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR, msg: 'Đã có lỗi xảy ra.'));
      //emiterror
    }
  }

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
        Future.delayed(const Duration(milliseconds: 500));
        if (list!.isNotEmpty) {
          listInvoice = list;
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

  void _loadMoreInvoice(InvoiceEvent event, Emitter emit) async {
    try {
      if (event is LoadMoreInvoice) {
        emit(state.copyWith(status: BlocStatus.LOAD_MORE));

        List<InvoiceFeeDTO>? list = await _invoiceRepository.getInvoiceList(
          status: event.status,
          bankId: event.bankId,
          filterBy: event.filterBy,
          time: event.time,
          page: event.page! + 1,
          size: event.size,
        );
        Future.delayed(const Duration(milliseconds: 1000));
        if (list!.isNotEmpty) {
          listInvoice += list;
          emit(state.copyWith(
              metaDataDTO: _invoiceRepository.metaDataDTO,
              listInvoice: listInvoice,
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
