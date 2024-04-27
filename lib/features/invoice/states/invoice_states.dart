import 'package:equatable/equatable.dart';
import 'package:vierqr/models/invoice_detail_dto.dart';

import '../../../commons/enums/enum_type.dart';
import '../../../models/bank_account_dto.dart';
import '../../../models/invoice_fee_dto.dart';
import '../../../models/metadata_dto.dart';

class InvoiceStates extends Equatable {
  final String? msg;
  final List<InvoiceFeeDTO>? listInvoice;
  final InvoiceType? request;
  final BlocStatus status;
  final MetaDataDTO? metaDataDTO;
  final InvoiceDetailDTO? invoiceDetailDTO;

  const InvoiceStates({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = InvoiceType.NONE,
    this.listInvoice,
    this.metaDataDTO,
    this.invoiceDetailDTO,
  });

  InvoiceStates copyWith({
    BlocStatus? status,
    InvoiceType? request,
    String? msg,
    List<InvoiceFeeDTO>? listInvoice,
    MetaDataDTO? metaDataDTO,
    InvoiceDetailDTO? invoiceDetailDTO,
  }) {
    return InvoiceStates(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      listInvoice: listInvoice ?? this.listInvoice,
      metaDataDTO: metaDataDTO ?? this.metaDataDTO,
      invoiceDetailDTO: invoiceDetailDTO ?? this.invoiceDetailDTO,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        listInvoice,
        metaDataDTO,
      ];
}
