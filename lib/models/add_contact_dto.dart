class AddContactDTO {
  final String? additionalData;
  final String? nickName;
  final int? type;
  final String? value;
  final String? userId;
  final String? bankTypeId;
  final String? bankAccount;

  AddContactDTO({
    this.additionalData,
    this.nickName,
    this.type,
    this.value,
    this.userId,
    this.bankTypeId,
    this.bankAccount,
  });

  factory AddContactDTO.fromJson(Map<String, dynamic> json) =>
      AddContactDTO(
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
