class VietQRGenerateDTO {
  //Consumer Account Information Value
  final String cAIValue;
  //Transaction Amount value
  final String transactionAmountValue;
  //Additional Data Field Template value
  final String additionalDataFieldTemplateValue;

  const VietQRGenerateDTO({
    required this.cAIValue,
    required this.transactionAmountValue,
    required this.additionalDataFieldTemplateValue,
  });
}
