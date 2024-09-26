class MerchantDTO {
  final String id;
  final String name;
  final String address;
  final String vsoCode;
  final int totalTerminals;

  MerchantDTO({
    this.id = '',
    this.name = '',
    this.address = '',
    this.vsoCode = '',
    this.totalTerminals = 0,
  });

  factory MerchantDTO.fromJson(Map<String, dynamic> json) => MerchantDTO(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        address: json["address"] ?? '',
        vsoCode: json["vsoCode"] ?? '',
        totalTerminals: json["totalTerminals"] ?? 0,
      );
}
