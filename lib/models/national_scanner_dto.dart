class NationalScannerDTO {
  final String nationalId;
  final String oldNationalId;
  final String fullname;
  final String birthdate;
  final String gender;
  final String address;
  final String dateValid;

  const NationalScannerDTO({
    required this.nationalId,
    required this.oldNationalId,
    required this.fullname,
    required this.birthdate,
    required this.gender,
    required this.address,
    required this.dateValid,
  });
}
