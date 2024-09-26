class UserBankDTO {
  final String id;
  final String userId;
  final String bankId;
  final String fullName;
  final String phoneNo;
  final String role;

  const UserBankDTO({
    required this.id,
    required this.userId,
    required this.bankId,
    required this.fullName,
    required this.phoneNo,
    required this.role,
  });
}
