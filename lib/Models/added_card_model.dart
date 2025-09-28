class AddedCardModel {
  final String id;
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cvvCode;
  final bool isChosen;

  AddedCardModel({
    required this.id,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cvvCode,
    this.isChosen = false,
  });

  AddedCardModel copyWith({
    String? id,
    String? cardNumber,
    String? cardHolder,
    String? expiryDate,
    String? cvvCode,
    bool? isChosen,
  }) {
    return AddedCardModel(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolder: cardHolder ?? this.cardHolder,
      expiryDate: expiryDate ?? this.expiryDate,
      cvvCode: cvvCode ?? this.cvvCode,
      isChosen: isChosen ?? this.isChosen,
    );
  }
}

List<AddedCardModel> cards = [
  AddedCardModel(
    id: '1',
    cardNumber: '12121212',
    cardHolder: 'Ahmed Khames',
    expiryDate: '55',
    cvvCode: '201',
  ),
  AddedCardModel(
    id: '2',
    cardNumber: '45654565',
    cardHolder: 'Basel Mahfouz',
    expiryDate: '55',
    cvvCode: '201',
  ),
];
