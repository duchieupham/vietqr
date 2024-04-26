class AnnualFeeDTO {
  String? feeId;
  int? duration;
  String? description;
  int? amount;
  int? totalAmount;
  double? vat;
  int? totalWithVat;

  AnnualFeeDTO({
    this.feeId,
    this.duration,
    this.description,
    this.amount,
    this.totalAmount,
    this.vat,
    this.totalWithVat,
  });

  factory AnnualFeeDTO.fromJson(Map<String, dynamic> json) {
    return AnnualFeeDTO(
      // statusCode: json["statusCode"],
      feeId: json['feeId'],
      duration: json['duration'],
      description: json['description'],
      amount: json['amount'],
      totalAmount: json['totalAmount'],
      vat: json['vat'],
      totalWithVat: json['totalWithVat'],
    );
  }
}

class ActiveAnnualStatus {
  int? statusCode;
  String? code;
  String? message;
  AnnualFeeActiveRes? res;
  AnnualFeeConfirm? confirm;

  ActiveAnnualStatus({
    this.statusCode,
    this.code,
    this.message,
    this.res,
    this.confirm,
  });

  factory ActiveAnnualStatus.fromJson(Map<String, dynamic> json) {
    return ActiveAnnualStatus(
      // statusCode: json["statusCode"],
      code: json["status"],
      message: json["message"],
      // dto: null,
    );
  }
}

class AnnualFeeConfirm {
  final String? qr;
  final String? billNumber;
  final String? bankLogo;
  final int? amount;

  const AnnualFeeConfirm({
    this.qr,
    this.billNumber,
    this.bankLogo,
    this.amount,
  });

  factory AnnualFeeConfirm.fromJson(Map<String, dynamic> json) {
    return AnnualFeeConfirm(
      qr: json['qr'],
      billNumber: json['billNumber'],
      bankLogo: json['bankLogo'],
      amount: json['amount'],
    );
  }
}

class AnnualFeeActiveRes {
  final String? otp;
  final int? duration;
  final int? validFrom;
  final int? validTo;
  final String? request;
  final String? otpPayment;
  final String? feeId;

  const AnnualFeeActiveRes(
      {this.otp,
      this.duration,
      this.validFrom,
      this.validTo,
      this.request,
      this.otpPayment,
      this.feeId});

  factory AnnualFeeActiveRes.fromJson(Map<String, dynamic> json) {
    return AnnualFeeActiveRes(
      // statusCode: json["statusCode"],
      otp: json['otp'],
      duration: json['duration'],
      validFrom: json['validFrom'],
      validTo: json['validTo'],
      request: json['request'],
      otpPayment: json['otpPayment'],
      feeId: json['feeId'],
    );
  }
}
