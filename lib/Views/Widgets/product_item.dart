import 'package:ecommerce/Models/product_item_model.dart';
import 'package:ecommerce/View_Models/home_cubit/home_cubit.dart';
import 'package:ecommerce/View_Models/favorite_cubit/favorite_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductItem extends StatelessWidget {
  final ProductItemModel productItem;
  const ProductItem({super.key, required this.productItem});

  @override
  Widget build(BuildContext context) {
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    final favoriteCubit = BlocProvider.of<FavoriteCubit>(context);

    Widget IconNavbar(String path, Color color) {
      return Image.asset(path, height: 10, width: 10, color: color);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 140,
              width: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0XFFEDF8E9),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: productItem.imgPath,
                  fit: BoxFit.contain,
                  memCacheHeight: 300,
                  memCacheWidth: 300,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: BlocBuilder<HomeCubit, HomeState>(
                bloc: homeCubit,
                buildWhen: (previous, current) {
                  // Only rebuild this specific product's favorite button
                  if (current is HomeLoaded) {
                    final prod = current.products.firstWhere(
                      (p) => p.id == productItem.id,
                      orElse: () => productItem,
                    );
                    final prevProd = previous is HomeLoaded
                        ? previous.products.firstWhere(
                            (p) => p.id == productItem.id,
                            orElse: () => productItem,
                          )
                        : productItem;
                    return prod.isFavorite != prevProd.isFavorite;
                  }
                  return false;
                },
                builder: (context, state) {
                  bool isFavorite = productItem.isFavorite;

                  if (state is HomeLoaded) {
                    final product = state.products.firstWhere(
                      (p) => p.id == productItem.id,
                      orElse: () => productItem,
                    );
                    isFavorite = product.isFavorite;
                  }

                  return InkWell(
                    onTap: () async {
                      print('=== Favorite Button Tapped ===');
                      print('Product: ${productItem.name}');
                      print('Current isFavorite: $isFavorite');

                      // Call setFavorite on HomeCubit
                      await homeCubit.setFavorite(productItem);

                      print('setFavorite completed');

                      // Wait a moment for the local update to complete
                      await Future.delayed(Duration(milliseconds: 300));

                      // Now refresh FavoriteCubit from server to sync
                      print('Refreshing FavoriteCubit...');
                      await favoriteCubit.getFavoriteProducts();

                      print('FavoriteCubit refreshed');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0XFF005A32),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: 30,
                        width: 30,
                        child: isFavorite
                            ? IconNavbar(
                                'assets/icons/favoriteF.png',
                                Colors.white,
                              )
                            : IconNavbar(
                                'assets/icons/favoriteO.png',
                                Colors.white,
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          productItem.name,
          style: TextStyle(fontSize: 24, color: Color(0xFF005A32)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 10),
        Text(
          productItem.brand,
          style: TextStyle(fontSize: 16, color: Color(0xFF41AB5D)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 10),
        Text(
          '\$ ${productItem.price.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 24, color: Color(0xFF005A32)),
        ),
      ],
    );
  }
}
