class MaintainChargeStatus {
  int? statusCode;
  String? code;
  String? message;
  MaintainChargeDTO? dto;

  MaintainChargeStatus({
    this.statusCode,
    this.code,
    this.message,
    this.dto,
  });

  factory MaintainChargeStatus.fromJson(Map<String, dynamic> json) {
    return MaintainChargeStatus(
      // statusCode: json["statusCode"],
      code: json["status"],
      message: json["message"],
      dto: null,
    );
  }
}

class MaintainChargeDTO {
  final String key;
  final int? duration;
  final int? validFrom;
  final int? validTo;
  final String? otp;

  const MaintainChargeDTO({
    required this.key,
    this.duration,
    this.validFrom,
    this.validTo,
    this.otp,
  });

  factory MaintainChargeDTO.fromJson(Map<String, dynamic> json) {
    return MaintainChargeDTO(
      key: json['key'],
      duration: json['duration'],
      validFrom: json['validFrom'],
      validTo: json['validTo'],
      otp: json['otp'],
    );
  }
}
