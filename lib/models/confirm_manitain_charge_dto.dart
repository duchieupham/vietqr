class ConfirmMaintainCharge {
  final String keyValue;
  final String otp;
  final String bankId;
  final String userId;
  final String password;

  ConfirmMaintainCharge({
    required this.keyValue,
    required this.otp,
    required this.bankId,
    required this.userId,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['key'] = keyValue;
    data['otp'] = otp;
    data['bankId'] = bankId;
    data['userId'] = userId;
    data['password'] = password;
    return data;
  }
}
