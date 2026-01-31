enum productSize {
  S,
  M,
  L,
  XL;

  static productSize fromString(String size) {
    switch (size.toUpperCase()) {
      case 'S':
        return productSize.S;
      case 'M':
        return productSize.M;
      case 'L':
        return productSize.L;
      case 'XL':
        return productSize.XL;
      default:
        return productSize.S;
    }
  }
}

class ProductItemModel {
  final String id;
  final String imgPath;
  final String name;
  final String brand;
  final double price;
  final bool isFavorite;
  final String category;
  final String average_rate;

  ProductItemModel({
    required this.id,
    required this.imgPath,
    required this.name,
    required this.brand,
    required this.price,
    this.isFavorite = false,
    this.category = 'Others',
    required this.average_rate,
  });

  ProductItemModel copyWith({
    String? id,
    String? name,
    String? imgPath,
    String? brand,
    double? price,
    bool? isFavorite,
    String? category,
    String? average_rate,
  }) {
    return ProductItemModel(
      id: id ?? this.id,
      imgPath: imgPath ?? this.imgPath,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
      average_rate: average_rate ?? this.average_rate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imgPath': imgPath,
      'name': name,
      'brand': brand,
      'price': price,
      'isFavorite': isFavorite,
      'category': category,
      'average_rate': average_rate,
    };
  }

  factory ProductItemModel.fromMap(Map<String, dynamic> map) {
    return ProductItemModel(
      id: map['id'] ?? '',
      imgPath: map['imgPath'] ?? '',
      name: map['name'] ?? '',
      brand: map['brand'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      isFavorite: map['isFavorite'] ?? false,
      category: map['category'] ?? 'Others',
      average_rate: map['average_rate'] ?? '0.0',
    );
  }
}

// List<ProductItemModel> products = [
//   ProductItemModel(
//     id: '1',
//     imgPath: 'assets/images/shoe.png',
//     name: 'Miracle Shoes',
//     brand: 'Adidas',
//     price: 99.9,
//     category: 'Shoes',
//     average_rate: '4.8',
//   ),
//   ProductItemModel(
//     id: '2',
//     imgPath: 'assets/images/bag.png',
//     name: 'Z262 Bag',
//     brand: 'H & Y',
//     price: 59.9,
//     category: 'Bags',
//     average_rate: '4.9',
//   ),
//   ProductItemModel(
//     id: '3',
//     imgPath: 'assets/images/tshirt2.png',
//     name: 'White T-Shirt',
//     brand: 'MMM',
//     price: 19.9,
//     category: 'T-Shirts',
//     average_rate: '4.6',
//   ),
//   ProductItemModel(
//     id: '4',
//     imgPath: 'assets/images/tshirt3.png',
//     name: 'Flying Bird',
//     brand: 'Flutter',
//     price: 6.9,
//     category: 'T-Shirts',
//     average_rate: '5.0',
//   ),
// ];
