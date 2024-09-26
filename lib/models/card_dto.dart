class CardDTO {
  final String cardNumber;
  final String cardNfcNumber;

  CardDTO({this.cardNumber = '', this.cardNfcNumber = ''});

  factory CardDTO.fromJson(Map<String, dynamic> json) {
    return CardDTO(
      cardNumber: json['cardNumber'] ?? '',
      cardNfcNumber: json['cardNfcNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['cardNumber'] = cardNumber;
    data['cardNfcNumber'] = cardNfcNumber;
    return data;
  }
}
