import 'package:ecommerce/Models/product_item_model.dart';
import 'package:ecommerce/View_Models/product_item_cubit/product_item_cubit.dart';
import 'package:ecommerce/Views/Widgets/counter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItemPage extends StatelessWidget {
  final String productId;
  const ProductItemPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ProductItemCubit>(context);

    Widget IconNavbar(String path, Color color) {
      return Image.asset(path, height: 30, width: 30, color: color);
    }

    return BlocBuilder<ProductItemCubit, ProductItemState>(
      bloc: cubit,
      buildWhen: (previous, current) =>
          current is ProductItemLoading ||
          current is ProductItemLoaded ||
          current is ProductItemError,
      builder: (context, state) {
        if (state is ProductItemLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
          );
        } else if (state is ProductItemLoaded) {
          final productItem = state.product;
          return Scaffold(
            backgroundColor: Color(0XFFEDF8E9),
            body: SafeArea(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 18,
                      right: 18,
                      top: 68,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconNavbar(
                              'assets/icons/chevronLeft.png',
                              Theme.of(context).primaryColor,
                            ),
                            IconNavbar(
                              'assets/icons/favoriteO_P.png',
                              Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                        Image.asset(productItem.imgPath),
                      ],
                    ),
                  ),
                  Align(
                    alignment: AlignmentGeometry.bottomCenter,
                    child: Container(
                      height: 424,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0XFF005A32),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 28,
                          right: 28,
                          top: 30,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productItem.name,
                                      style: TextStyle(
                                        fontSize: 32,
                                        color: Color(0XFFEDF8E9),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/star.png',
                                          height: 25,
                                          width: 25,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          productItem.average_rate,
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: Color(0XFFEDF8E9),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                BlocBuilder<ProductItemCubit, ProductItemState>(
                                  bloc: cubit,
                                  buildWhen: (previous, current) =>
                                      current is CounterQuantityLoaded ||
                                      current is ProductItemLoaded,
                                  builder: (context, state) {
                                    if (state is CounterQuantityLoaded) {
                                      return CounterWidget(
                                        value: state.value,
                                        productId: productItem.id,
                                        cubit: cubit,
                                      );
                                    } else if (state is ProductItemLoaded) {
                                      return CounterWidget(
                                        value: 1,
                                        productId: productItem.id,
                                        cubit: cubit,
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Size',
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: Color(0XFFEDF8E9),
                                  ),
                                ),
                                BlocBuilder<ProductItemCubit, ProductItemState>(
                                  bloc: cubit,
                                  buildWhen: (previous, current) =>
                                      current is sizeSelected ||
                                      current is ProductItemLoaded,
                                  builder: (context, state) {
                                    return Row(
                                      children: productSize.values
                                          .map(
                                            (size) => Padding(
                                              padding: const EdgeInsets.only(
                                                left: 20,
                                              ),
                                              child: InkWell(
                                                onTap: () =>
                                                    cubit.selectSize(size),
                                                child: SizedBox(
                                                  height: 40,
                                                  width: 40,
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          state is sizeSelected &&
                                                              state.size == size
                                                          ? Color(0XFF41AB5D)
                                                          : Color(0XFFEDF8E9),
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        size.name,
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          color:
                                                              state
                                                                      is sizeSelected &&
                                                                  state.size ==
                                                                      size
                                                              ? Color(
                                                                  0XFFEDF8E9,
                                                                )
                                                              : Theme.of(
                                                                  context,
                                                                ).primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 32,
                                color: Color(0xFFEDF8E9),
                              ),
                            ),
                            Text(
                              'LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum LoremIpsum',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFFEDF8E9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 76,
                      decoration: BoxDecoration(
                        color: Color(0XFFEDF8E9),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 15,
                          left: 15,
                          top: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: '\$ ',
                                children: [
                                  TextSpan(
                                    text: '${productItem.price}',
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Color(0XFF41AB5D),
                                ),
                              ),
                            ),
                            Container(
                              height: 55,
                              width: 197,
                              child:
                                  BlocBuilder<
                                    ProductItemCubit,
                                    ProductItemState
                                  >(
                                    bloc: cubit,
                                    buildWhen: (previous, current) =>
                                        current is ProductAddedToCart ||
                                        current is ProductAddingToCart,
                                    builder: (context, state) {
                                      if (state is ProductAddingToCart) {
                                        return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(
                                              context,
                                            ).primaryColor,
                                          ),
                                          onPressed: null,
                                          child:
                                              CircularProgressIndicator.adaptive(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                      Color(0XFFEDF8E9),
                                                    ),
                                              ),
                                        );
                                      } else if (state is ProductAddedToCart) {
                                        return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0XFFEDF8E9),
                                          ),
                                          onPressed: null,
                                          child: Text(
                                            'Added To Cart!',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Color(0XFF005A32),
                                            ),
                                          ),
                                        );
                                      }
                                      return ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(
                                            context,
                                          ).primaryColor,
                                          foregroundColor: Color(0XFFEDF8E9),
                                        ),
                                        onPressed: () {
                                          if (cubit.selectedSize != null) {
                                            cubit.addToCart(productItem.id);
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Please Select Size',
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        label: const Text(
                                          'Add To Cart',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        icon: IconNavbar(
                                          'assets/icons/ordersO.png',
                                          Color(0xFFEDF8E9),
                                        ),
                                      );
                                    },
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold();
        }
      },
    );
  }
}
