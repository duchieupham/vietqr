class ResponseObjectDTO {
  final String status;
  final CustomerVaResponseOtpDTO data;

  ResponseObjectDTO({
    required this.status,
    required this.data,
  });

  factory ResponseObjectDTO.fromJson(Map<String, dynamic> json) {
    return ResponseObjectDTO(
      status: json['status'],
      data: CustomerVaResponseOtpDTO.fromJson(
        json['data'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['status'] = status;
    json['data'] = data.toJson();
    return json;
  }
}

class CustomerVaResponseOtpDTO {
  final String merchantId;
  final String confirmId;

  CustomerVaResponseOtpDTO({required this.merchantId, required this.confirmId});

  factory CustomerVaResponseOtpDTO.fromJson(Map<String, dynamic> json) {
    return CustomerVaResponseOtpDTO(
      merchantId: json['merchantId'],
      confirmId: json['confirmId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['merchantId'] = merchantId;
    data['confirmId'] = confirmId;
    return data;
  }
}
