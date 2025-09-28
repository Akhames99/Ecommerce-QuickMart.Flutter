class LocationItemModel {
  final String id;
  final String city;
  final String country;
  final String locationImg;
  final bool isChosen;

  LocationItemModel({
    required this.id,
    required this.city,
    required this.country,
    this.locationImg = 'assets/images/locationPattern.jpg',
    this.isChosen = false,
  });

  LocationItemModel copyWith({
    String? id,
    String? city,
    String? country,
    String? locationImg,
    bool? isChosen,
  }) {
    return LocationItemModel(
      id: id ?? this.id,
      city: city ?? this.city,
      country: country ?? this.country,
      locationImg: locationImg ?? this.locationImg,
      isChosen: isChosen ?? this.isChosen,
    );
  }
}

List<LocationItemModel> locations = [
  LocationItemModel(id: '1', city: 'Cairo', country: 'Egypt'),
  LocationItemModel(id: '2', city: 'Giza', country: 'Egypt'),
  LocationItemModel(id: '3', city: 'Alex', country: 'Egypt'),
];
