import 'package:equatable/equatable.dart';
import 'package:vierqr/models/invoice_detail_dto.dart';
import 'package:vierqr/models/unpaid_invoice_detail_qr_dto.dart';

import '../../../commons/enums/enum_type.dart';
import '../../../models/invoice_fee_dto.dart';
import '../../../models/metadata_dto.dart';

class InvoiceStates extends Equatable {
  final String? msg;
  final List<InvoiceFeeDTO>? listInvoice;
  final InvoiceType? request;
  final BlocStatus status;
  final MetaDataDTO? metaDataDTO;
  final InvoiceDetailDTO? invoiceDetailDTO;
  final UnpaidInvoiceDetailQrDTO? unpaidInvoiceDetailQrDTO;

  const InvoiceStates({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = InvoiceType.NONE,
    this.listInvoice,
    this.metaDataDTO,
    this.invoiceDetailDTO,
    this.unpaidInvoiceDetailQrDTO,
  });

  InvoiceStates copyWith({
    BlocStatus? status,
    InvoiceType? request,
    String? msg,
    List<InvoiceFeeDTO>? listInvoice,
    MetaDataDTO? metaDataDTO,
    InvoiceDetailDTO? invoiceDetailDTO,
    UnpaidInvoiceDetailQrDTO? unpaidInvoiceDetailQrDTO,
  }) {
    return InvoiceStates(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      listInvoice: listInvoice ?? this.listInvoice,
      metaDataDTO: metaDataDTO ?? this.metaDataDTO,
      invoiceDetailDTO: invoiceDetailDTO ?? this.invoiceDetailDTO,
      unpaidInvoiceDetailQrDTO:
          unpaidInvoiceDetailQrDTO ?? this.unpaidInvoiceDetailQrDTO,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        listInvoice,
        unpaidInvoiceDetailQrDTO,
        metaDataDTO,
      ];
}
