class ProductItemModel {
  final String id;
  final String imgPath;
  final String name;
  final String brand;
  final double price;
  final bool isFavorite;
  final String category;

  ProductItemModel({
    required this.id,
    required this.imgPath,
    required this.name,
    required this.brand,
    required this.price,
    this.isFavorite = false,
    this.category = 'Others',
  });
}

List<ProductItemModel> products = [
  ProductItemModel(
    id: '1',
    imgPath: 'assets/images/shoe.png',
    name: 'Miracle Shoes',
    brand: 'Adidas',
    price: 99.9,
    category: 'Shoes',
  ),
  ProductItemModel(
    id: '2',
    imgPath: 'assets/images/bag.png',
    name: 'Z262 Bag',
    brand: 'H & Y',
    price: 59.9,
    category: 'Bags',
  ),
  ProductItemModel(
    id: '3',
    imgPath: 'assets/images/tshirt2.png',
    name: 'White T-Shirt',
    brand: 'MMM',
    price: 19.9,
    category: 'T-Shirts',
  ),
  ProductItemModel(
    id: '4',
    imgPath: 'assets/images/tshirt3.png',
    name: 'Flying Bird',
    brand: 'Flutter',
    price: 6.9,
    category: 'T-Shirts',
  ),
];
