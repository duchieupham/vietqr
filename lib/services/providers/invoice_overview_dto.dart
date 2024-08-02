class Invoice {
  final String invoiceName;
  final int totalAmount;
  final String invoiceId;

  Invoice({
    required this.invoiceName,
    required this.totalAmount,
    required this.invoiceId,
  });

  // Factory constructor to create an instance from a JSON map
  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      invoiceName: json['invoiceName'],
      totalAmount: json['totalAmount'],
      invoiceId: json['invoiceId'],
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'invoiceName': invoiceName,
      'totalAmount': totalAmount,
      'invoiceId': invoiceId,
    };
  }
}

class InvoiceOverviewDTO {
  final int countInvoice;
  final int amountUnpaid;
  final List<Invoice> invoices;

  InvoiceOverviewDTO({
    required this.countInvoice,
    required this.amountUnpaid,
    required this.invoices,
  });

  // Factory constructor to create an instance from a JSON map
  factory InvoiceOverviewDTO.fromJson(Map<String, dynamic> json) {
    return InvoiceOverviewDTO(
      countInvoice: json['countInvoice'],
      amountUnpaid: json['amountUnpaid'],
      invoices: (json['invoices'] as List)
          .map((invoice) => Invoice.fromJson(invoice))
          .toList(),
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'countInvoice': countInvoice,
      'amountUnpaid': amountUnpaid,
      'invoices': invoices.map((invoice) => invoice.toJson()).toList(),
    };
  }
}
