import 'package:equatable/equatable.dart';

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

  const InvoiceStates({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = InvoiceType.NONE,
    this.listInvoice,
    this.metaDataDTO,
  });

  InvoiceStates copyWith({
    BlocStatus? status,
    InvoiceType? request,
    String? msg,
    List<InvoiceFeeDTO>? listInvoice,
    MetaDataDTO? metaDataDTO,
  }) {
    return InvoiceStates(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      listInvoice: listInvoice ?? this.listInvoice,
      metaDataDTO: metaDataDTO ?? this.metaDataDTO,
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
