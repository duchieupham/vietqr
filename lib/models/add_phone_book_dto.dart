class AddPhoneBookDTO {
  final String? additionalData;
  final String? nickName;
  final int? type;
  final String? value;
  final String? userId;
  final String? bankTypeId;
  final String? bankAccount;

  AddPhoneBookDTO({
    this.additionalData,
    this.nickName,
    this.type,
    this.value,
    this.userId,
    this.bankTypeId,
    this.bankAccount,
  });

  factory AddPhoneBookDTO.fromJson(Map<String, dynamic> json) =>
      AddPhoneBookDTO(
        additionalData: json["additionalData"],
        nickName: json["nickName"],
        type: json["type"],
        value: json["value"],
        userId: json["userId"],
        bankTypeId: json["bankTypeId"],
        bankAccount: json["bankAccount"],
      );

  Map<String, dynamic> toJson() => {
        "additionalData": additionalData,
        "nickName": nickName,
        "type": type,
        "value": value,
        "userId": userId,
        "bankTypeId": bankTypeId,
        "bankAccount": bankAccount,
      };
}
