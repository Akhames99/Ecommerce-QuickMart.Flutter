import 'package:bloc/bloc.dart';
import 'package:ecommerce/Models/add_to_cart_model.dart';
import 'package:ecommerce/Models/product_item_model.dart';

part 'product_item_state.dart';

class ProductItemCubit extends Cubit<ProductItemState> {
  ProductItemCubit() : super(ProductItemInitial());

  productSize? selectedSize;
  int quantity = 1;

  void getProductItem(String id) {
    emit(ProductItemLoading());
    Future.delayed(const Duration(seconds: 1), () {
      final selectedProduct = products.firstWhere((item) => item.id == id);
      emit(ProductItemLoaded(product: selectedProduct));
    });
  }

  void selectSize(productSize size) {
    selectedSize = size;
    emit(sizeSelected(size: size));
  }

  void addToCart(String productId) {
    emit(ProductAddingToCart());
    final cartItem = AddToCartModel(
      id: DateTime.now().toIso8601String(),
      product: products.firstWhere((item) => item.id == productId),
      size: selectedSize!,
      quantity: quantity,
    );
    theCart.add(cartItem);
    Future.delayed(Duration(seconds: 1), () {
      emit(ProductAddedToCart(productId: productId));
    });
  }

  void incrementCounter(String productId) {
    quantity++;
    emit(CounterQuantityLoaded(value: quantity));
  }

  void decrementCounter(String productId) {
    quantity--;
    emit(CounterQuantityLoaded(value: quantity));
  }
}
