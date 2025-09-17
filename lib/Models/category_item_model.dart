class CategoryItemModel {
  final String id;
  final String imgPath;
  final String name;

  CategoryItemModel({
    required this.id,
    required this.imgPath,
    this.name = 'UnCategorized',
  });
}

List<CategoryItemModel> categoryItems = [
  CategoryItemModel(
    id: '1',
    imgPath: 'assets/images/cClothes.jpg',
    name: 'Clothes',
  ),
  CategoryItemModel(id: '2', imgPath: 'assets/images/cBags.jpg', name: 'Bags'),
  CategoryItemModel(
    id: '3',
    imgPath: 'assets/images/cShoes.jpg',
    name: 'Shoes',
  ),
  CategoryItemModel(id: '4', imgPath: 'assets/images/cHats.jpg', name: 'Hats'),
];
