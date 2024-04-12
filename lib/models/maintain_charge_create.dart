class MaintainChargeCreate {
  final int type;
  final String key;
  final String bankId;
  final String userId;
  final String password;

  const MaintainChargeCreate({
    required this.type,
    required this.key,
    required this.bankId,
    required this.userId,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['type'] = type;
    data['key'] = key;
    data['bankId'] = bankId;
    data['userId'] = userId;
    data['password'] = password;
    return data;
  }
}
