import 'package:equatable/equatable.dart';

class InvoiceEvent extends Equatable {
  const InvoiceEvent();
  @override
  List<Object?> get props => [];
}

class GetInvoiceList extends InvoiceEvent {
  final int? status;
  final String? bankId;
  final int? filterBy;
  final String? time;
  final int? page;
  final int? size;

  const GetInvoiceList(
      {required this.status,
      required this.bankId,
      required this.filterBy,
      this.time,
      this.page,
      this.size});

  @override
  List<Object?> get props => [status, bankId, filterBy, time, page, size];
}

class RequestMultiInvoicePaymentEvent extends InvoiceEvent {
  final List<String> invoiceIds;

  const RequestMultiInvoicePaymentEvent({required this.invoiceIds});

  @override
  List<Object?> get props => [invoiceIds];
}

class GetInvoiceDetail extends InvoiceEvent {
  final String invoiceId;

  const GetInvoiceDetail(
    this.invoiceId,
  );

  @override
  List<Object?> get props => [invoiceId];
}

class LoadMoreInvoice extends InvoiceEvent {
  final int? status;
  final String? bankId;
  final int? filterBy;
  final String? time;
  final int? page;
  final int? size;

  const LoadMoreInvoice(
      {required this.status,
      required this.bankId,
      required this.filterBy,
      this.time,
      this.page,
      this.size});

  @override
  List<Object?> get props => [status, bankId, filterBy, time, page, size];
}
