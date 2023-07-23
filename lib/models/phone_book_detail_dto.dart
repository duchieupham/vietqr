class PhoneBookDetailDTO {
  final String? id;
  final String? additionalData;
  final String? nickName;
  final int? type;
  final int? status;
  final String? value;
  final String? bankShortName;
  final String? bankName;
  final String? imgId;
  final String? bankAccount;
  PhoneBookDetailDTO({
    this.id = '',
    this.additionalData = '',
    this.nickName = '',
    this.type = 0,
    this.status = 0,
    this.value = '',
    this.bankShortName = '',
    this.bankName = '',
    this.imgId = '',
    this.bankAccount = '',
  });

  factory PhoneBookDetailDTO.fromJson(Map<String, dynamic> json) =>
      PhoneBookDetailDTO(
        additionalData: json["additionalData"],
        nickName: json["nickname"],
        type: json["type"],
        value: json["value"],
        id: json["id"],
        status: json["status"],
        bankShortName: json["bankShortName"],
        imgId: json["imgId"],
        bankAccount: json["bankAccount"],
        bankName: json["bankName"],
      );

  Map<String, dynamic> toJson() => {
        "additionalData": additionalData,
        "nickName": nickName,
        "type": type,
        "value": value,
        "bankName": bankName,
        "bankAccount": bankAccount,
        "imgId": imgId,
        "bankShortName": bankShortName,
        "status": status,
        "id": id,
      };
}
