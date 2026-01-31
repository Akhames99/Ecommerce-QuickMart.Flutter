import 'package:ecommerce/Utils/app_colors.dart';
import 'package:ecommerce/View_Models/favorite_cubit/favorite_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget iconNavbar(String path) {
      return Image.asset(
        path,
        height: 30,
        width: 30,
        color: Theme.of(context).primaryColor,
      );
    }

    final favoriteCubit = BlocProvider.of<FavoriteCubit>(context);
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      bloc: favoriteCubit,
      buildWhen: (previous, current) =>
          current is FavoriteLoaded ||
          current is FavoriteLoading ||
          current is FavoriteError,
      builder: (context, state) {
        if (state is FavoriteLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.primarycolor),
            ),
          );
        } else if (state is FavoriteLoaded) {
          final favorites = state.favoriteProducts;
          if (favorites.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                toolbarHeight: 80,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          foregroundImage: AssetImage(
                            'assets/images/profileIcon.jpg',
                          ),
                          radius: 28,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, Ahmed',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF005A32),
                              ),
                            ),
                            Text(
                              'What Will You Buy Today!',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF41AB5D),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        iconNavbar('assets/icons/search.png'),
                        SizedBox(width: 10),
                        iconNavbar('assets/icons/notification.png'),
                      ],
                    ),
                  ],
                ),
              ),
              body: const Center(child: Text('No favorites added yet.')),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              favoriteCubit.getFavoriteProducts();
            },
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                toolbarHeight: 80,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          foregroundImage: AssetImage(
                            'assets/images/profileIcon.jpg',
                          ),
                          radius: 28,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, Ahmed',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF005A32),
                              ),
                            ),
                            Text(
                              'What Will You Buy Today!',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF41AB5D),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        iconNavbar('assets/icons/search.png'),
                        SizedBox(width: 10),
                        iconNavbar('assets/icons/notification.png'),
                      ],
                    ),
                  ],
                ),
              ),
              body: ListView.separated(
                itemCount: favorites.length,
                separatorBuilder: (context, index) =>
                    const Divider(indent: 20, endIndent: 20),
                itemBuilder: (context, index) {
                  final favorite = favorites[index];
                  return ListTile(
                    title: Text(favorite.name),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.bgcolor,
                      backgroundImage: NetworkImage(favorite.imgPath),
                      radius: 30,
                    ),
                    subtitle: Text('\$${favorite.price.toStringAsFixed(2)}'),
                    trailing: BlocConsumer<FavoriteCubit, FavoriteState>(
                      bloc: favoriteCubit,
                      listenWhen: (previous, current) =>
                          current is FavoriteRemoveError,
                      listener: (context, state) {
                        if (state is FavoriteRemoveError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Error removing favorite: ${state.message}',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      buildWhen: (previous, current) =>
                          (current is FavoriteRemoving &&
                              current.productId == favorite.id) ||
                          (current is FavoriteRemoved &&
                              current.productId == favorite.id) ||
                          current is FavoriteRemoveError,
                      builder: (context, state) {
                        if (state is FavoriteRemoving) {
                          return const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.primarycolor,
                              ),
                            ),
                          );
                        }
                        return IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await favoriteCubit.removeFavorite(favorite.id);
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        } else if (state is FavoriteError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('Unexpected state.'));
        }
      },
    );
  }
}
