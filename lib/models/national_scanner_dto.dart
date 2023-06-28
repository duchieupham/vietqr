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

  String convertDate(String data) {
    if (data.isNotEmpty) {
      String day = data.substring(0, 2);
      String month = data.substring(2, 4);
      String year = data.substring(4, data.length);

      return '$day/$month/$year';
    }
    return '';
  }

  String get getBirth => convertDate(birthdate ?? '');

  String get getDateValid => convertDate(dateValid ?? '');

  factory NationalScannerDTO.fromJson(list) {
    return NationalScannerDTO(
      nationalId: list[0],
      oldNationalId: list[1],
      fullname: list[2],
      birthdate: list[3],
      gender: list[4],
      address: list[5],
      dateValid: list[6],
    );
  }
}
