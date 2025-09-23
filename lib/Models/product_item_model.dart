enum productSize { S, M, L, XL }

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
      average_rate: average_rate ?? this.average_rate,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
    );
  }
}

List<ProductItemModel> products = [
  ProductItemModel(
    id: '1',
    imgPath: 'assets/images/shoe.png',
    name: 'Miracle Shoes',
    brand: 'Adidas',
    price: 99.9,
    category: 'Shoes',
    average_rate: '4.8',
  ),
  ProductItemModel(
    id: '2',
    imgPath: 'assets/images/bag.png',
    name: 'Z262 Bag',
    brand: 'H & Y',
    price: 59.9,
    category: 'Bags',
    average_rate: '4.9',
  ),
  ProductItemModel(
    id: '3',
    imgPath: 'assets/images/tshirt2.png',
    name: 'White T-Shirt',
    brand: 'MMM',
    price: 19.9,
    category: 'T-Shirts',
    average_rate: '4.6',
  ),
  ProductItemModel(
    id: '4',
    imgPath: 'assets/images/tshirt3.png',
    name: 'Flying Bird',
    brand: 'Flutter',
    price: 6.9,
    category: 'T-Shirts',
    average_rate: '5.0',
  ),
];
