class BankEnableType {
  final String bankId;
  final String notificationTypes;

  // Constructor
  BankEnableType({
    required this.bankId,
    required this.notificationTypes,
  });

  // Factory method to create an instance from JSON
  factory BankEnableType.fromJson(Map<String, dynamic> json) {
    return BankEnableType(
      bankId: json['bankId'] as String,
      notificationTypes: json['notificationTypes'] as String,
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'bankId': bankId,
      'notificationTypes': notificationTypes,
    };
  }
}
