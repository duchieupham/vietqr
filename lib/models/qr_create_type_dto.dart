class QrCreateFeedDTO {
  String typeDto;
  String userIdDTO;
  String qrNameDTO;
  String qrDescriptionDTO;
  String valueDTO;
  String pinDTO;
  String? fullNameDTO;
  String? phoneNoDTO;
  String? emailDTO;
  String? companyNameDTO;
  String? websiteDTO;
  String? addressDTO;
  String? additionalDataDTO;
  String? bankAccountDTO;
  String? bankCodeDTO;
  String? userBankNameDTO;
  String? amountDTO;
  String? contentDTO;
  String isPublicDTO;
  String styleDTO;
  String themeDTO;

  QrCreateFeedDTO({
    required this.typeDto,
    required this.userIdDTO,
    required this.qrNameDTO,
    required this.qrDescriptionDTO,
    required this.valueDTO,
    required this.pinDTO,
    required this.fullNameDTO,
    required this.phoneNoDTO,
    required this.emailDTO,
    required this.companyNameDTO,
    required this.websiteDTO,
    required this.addressDTO,
    required this.additionalDataDTO,
    required this.bankAccountDTO,
    required this.bankCodeDTO,
    required this.userBankNameDTO,
    required this.amountDTO,
    required this.contentDTO,
    required this.isPublicDTO,
    required this.styleDTO,
    required this.themeDTO,
  });

  Map<String, dynamic> toJson() {
    return {
      'typeDto': typeDto,
      'userIdDTO': userIdDTO,
      'qrNameDTO': qrNameDTO,
      'qrDescriptionDTO': qrDescriptionDTO,
      'valueDTO': valueDTO,
      'pinDTO': pinDTO,
      'fullNameDTO': fullNameDTO,
      'phoneNoDTO': phoneNoDTO,
      'emailDTO': emailDTO,
      'companyNameDTO': companyNameDTO,
      'websiteDTO': websiteDTO,
      'addressDTO': addressDTO,
      'additionalDataDTO': additionalDataDTO,
      'bankAccountDTO': bankAccountDTO,
      'bankCodeDTO': bankCodeDTO,
      'userBankNameDTO': userBankNameDTO,
      'amountDTO': amountDTO,
      'contentDTO': contentDTO,
      'isPublicDTO': isPublicDTO,
      'styleDTO': styleDTO,
      'themeDTO': themeDTO,
    };
  }
}
