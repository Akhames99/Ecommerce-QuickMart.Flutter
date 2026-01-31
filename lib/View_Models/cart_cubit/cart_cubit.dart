import 'package:ecommerce/Models/add_to_cart_model.dart';
import 'package:ecommerce/Services/auth_services.dart';
import 'package:ecommerce/Services/cart_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final cartServices = CartServicesImpl();
  final authServices = AuthServicesImpl();

  /// Always initialize your cart list
  List<AddToCartModel> theCart = [];

  /// Fetch all cart items from Firestore
  Future<void> getCartItems() async {
    emit(CartLoading());
    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        emit(CartError(message: 'User not logged in.'));
        return;
      }

      final cartItems = await cartServices.fetchCartItems(currentUser.uid);
      theCart = List.from(cartItems);

      final subtotal = _calculateSubTotal();
      emit(CartLoaded(cartItems: List.from(theCart), subTotal: subtotal));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  /// Add item to cart or update existing one
  void addToCart(AddToCartModel item) {
    final index = theCart.indexWhere(
      (cartItem) =>
          cartItem.product.id == item.product.id && cartItem.size == item.size,
    );

    if (index != -1) {
      theCart[index].quantity += item.quantity;
    } else {
      theCart.add(item);
    }

    final subTotal = _calculateSubTotal();
    emit(CartLoaded(cartItems: List.from(theCart), subTotal: subTotal));
  }

  /// Increment quantity in cart and update Firestore
  Future<void> incrementCounter(
    AddToCartModel cartItem,
    String productId,
  ) async {
    final currentUser = authServices.currentUser();
    if (currentUser == null) {
      emit(CartError(message: 'User not logged in.'));
      return;
    }

    if (theCart.isEmpty) {
      emit(CartError(message: 'Cart is empty.'));
      return;
    }

    final index = theCart.indexWhere((item) => item.product.id == productId);

    if (index == -1) {
      emit(CartError(message: 'Item not found in cart.'));
      return;
    }

    theCart[index].quantity++;
    final updatedCartItem = cartItem.copyWith(
      quantity: theCart[index].quantity,
    );

    await cartServices.setCartItem(currentUser.uid, updatedCartItem);

    final subTotal = _calculateSubTotal();
    emit(CartLoaded(cartItems: List.from(theCart), subTotal: subTotal));
  }

  /// Decrement quantity in cart and update Firestore
  Future<void> decrementCounter(
    AddToCartModel cartItem,
    String productId,
  ) async {
    final currentUser = authServices.currentUser();
    if (currentUser == null) {
      emit(CartError(message: 'User not logged in.'));
      return;
    }

    final index = theCart.indexWhere((item) => item.product.id == productId);

    if (index == -1) {
      emit(CartError(message: 'Item not found in cart.'));
      return;
    }

    if (theCart[index].quantity > 1) {
      theCart[index].quantity--;
      final updatedCartItem = cartItem.copyWith(
        quantity: theCart[index].quantity,
      );

      await cartServices.setCartItem(currentUser.uid, updatedCartItem);
      final subTotal = _calculateSubTotal();

      emit(CartLoaded(cartItems: List.from(theCart), subTotal: subTotal));
    } else {
      emit(CartError(message: 'Minimum quantity reached.'));
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

  /// Calculate total price
  double _calculateSubTotal() {
    return theCart.fold<double>(
      0,
      (previousValue, item) =>
          previousValue + (item.product.price * item.quantity),
    );
  }
}
