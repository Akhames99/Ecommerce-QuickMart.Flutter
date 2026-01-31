// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'city': city,
      'country': country,
      'locationImg': locationImg,
      'isChosen': isChosen,
    };
  }

  factory LocationItemModel.fromMap(Map<String, dynamic> map) {
    return LocationItemModel(
      id: map['id'] as String,
      city: map['city'] as String,
      country: map['country'] as String,
      locationImg: map['locationImg'] as String,
      isChosen: map['isChosen'] as bool,
    );
  }
}

List<LocationItemModel> locations = [
  LocationItemModel(id: '1', city: 'Cairo', country: 'Egypt'),
  LocationItemModel(id: '2', city: 'Giza', country: 'Egypt'),
  LocationItemModel(id: '3', city: 'Alex', country: 'Egypt'),
];
