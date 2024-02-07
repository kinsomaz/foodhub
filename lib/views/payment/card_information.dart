class CardInformation {
  final String name;
  final String cardNumber;
  final String cvv;
  final String expiryMonth;
  final String expiryYear;
  final String displayName;

  CardInformation({
    required this.name,
    required this.cardNumber,
    required this.cvv,
    required this.expiryMonth,
    required this.expiryYear,
    required this.displayName,
  });

  CardInformation.fromDatabase(Map<String, dynamic> data)
      : name = data['name'] ?? '',
        cardNumber = data['card_number'] ?? '',
        cvv = data['cvv'] ?? '',
        expiryMonth = data['expiry_month'] ?? '',
        expiryYear = data['expiry_year'] ?? '',
        displayName = data['display_name'];
}
