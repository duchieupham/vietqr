class AccountLoginDTO {
  final String phoneNo;
  final String password;

  const AccountLoginDTO({required this.phoneNo, required this.password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['phoneNo'] = phoneNo;
    data['password'] = password;
    return data;
  }
}
