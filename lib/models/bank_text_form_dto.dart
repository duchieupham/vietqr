class BankTextFormDTO {
  final String id;
  final String text;
  final String bankId;

  const BankTextFormDTO({
    required this.id,
    required this.text,
    required this.bankId,
  });

  factory BankTextFormDTO.fromJson(Map<String, dynamic> json) {
    return BankTextFormDTO(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      bankId: json['bank_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['id'] = id;
    data['text'] = text;
    data['bank_id'] = bankId;
    return data;
  }
}
