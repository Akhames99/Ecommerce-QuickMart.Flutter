import 'package:ecommerce/View_Models/home_cubit/home_cubit.dart';
import 'package:ecommerce/Views/Widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class HomeTabview extends StatelessWidget {
  const HomeTabview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: BlocProvider.of<HomeCubit>(context),
      builder: (context, state) {
        if (state is HomeLoading) {
          return Center(child: CircularProgressIndicator.adaptive());
        } else if (state is HomeLoaded) {
          return SingleChildScrollView(
            child: Column(
              children: [
                FlutterCarousel.builder(
                  itemCount: state.carouselItems.length,
                  itemBuilder:
                      (
                        BuildContext context,
                        int itemIndex,
                        int pageViewIndex,
                      ) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(30),
                          child: Image.asset(
                            width: 353,
                            state.carouselItems[itemIndex].path,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  options: FlutterCarouselOptions(
                    height: 202.0,
                    showIndicator: true,
                    slideIndicator: CircularWaveSlideIndicator(),
                    enableInfiniteScroll: true,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New Arrivals',
                      style: TextStyle(fontSize: 24, color: Color(0xFF005A32)),
                    ),
                    Text(
                      'See All',
                      style: TextStyle(fontSize: 20, color: Color(0xFF41AB5D)),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.60,
                  ),
                  itemBuilder: (context, index) {
                    return ProductItem(productItem: state.products[index]);
                  },
                ),
              ],
            ),
          );
        } else if (state is HomeError) {
          return Center(
            child: Text(
              state.errorMessage,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
