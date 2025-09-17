class HomeCarouselItemModel {
  final String id;
  final String path;

  HomeCarouselItemModel({required this.id, required this.path});
}

List<HomeCarouselItemModel> homeCarousel = [
  HomeCarouselItemModel(id: '1', path: 'assets/images/sales.jpg'),
  HomeCarouselItemModel(id: '2', path: 'assets/images/sales2.jpeg'),
  HomeCarouselItemModel(id: '3', path: 'assets/images/sales3.jpeg'),
];
