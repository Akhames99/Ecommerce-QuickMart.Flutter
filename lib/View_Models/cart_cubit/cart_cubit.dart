import 'package:ecommerce/Models/add_to_cart_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  /// Load items from theCart and calculate subtotal
  void getCartItems() {
    emit(CartLoading());
    final subTotal = _calculateSubTotal();
    emit(CartLoaded(cartItems: List.from(theCart), subTotal: subTotal));
  }

  /// Add a new item to the cart
  void addToCart(AddToCartModel item) {
    // Check if the same product+size already exists in the cart
    final index = theCart.indexWhere(
      (cartItem) =>
          cartItem.product.id == item.product.id && cartItem.size == item.size,
    );

    if (index != -1) {
      // If exists → increase its quantity
      theCart[index].quantity += item.quantity;
    } else {
      // Otherwise → add it
      theCart.add(item);
    }

    final subTotal = _calculateSubTotal();
    emit(CartLoaded(cartItems: List.from(theCart), subTotal: subTotal));
  }

  /// Increment quantity for a given product
  void incrementCounter(String productId) {
    final index = theCart.indexWhere((item) => item.id == productId);
    if (index != -1) {
      theCart[index].quantity++;
      final subTotal = _calculateSubTotal();
      emit(CartLoaded(cartItems: List.from(theCart), subTotal: subTotal));
    }
  }

  /// Decrement quantity (not less than 1)
  void decrementCounter(String productId) {
    final index = theCart.indexWhere((item) => item.id == productId);
    if (index != -1 && theCart[index].quantity > 1) {
      theCart[index].quantity--;
      final subTotal = _calculateSubTotal();
      emit(CartLoaded(cartItems: List.from(theCart), subTotal: subTotal));
    }
  }

  /// Remove item completely
  void removeFromCart(String productId) {
    theCart.removeWhere((item) => item.id == productId);
    final subTotal = _calculateSubTotal();
    emit(CartLoaded(cartItems: List.from(theCart), subTotal: subTotal));
  }

  /// Clear all items
  void clearCart() {
    theCart.clear();
    emit(CartLoaded(cartItems: [], subTotal: 0));
  }

  /// Calculate subtotal (price * quantity)
  double _calculateSubTotal() {
    return theCart.fold<double>(
      0,
      (previousValue, item) =>
          previousValue + item.product.price * item.quantity,
    );
  }
}
