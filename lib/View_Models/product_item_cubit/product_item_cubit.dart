import 'package:bloc/bloc.dart';
import 'package:ecommerce/Models/add_to_cart_model.dart';
import 'package:ecommerce/Models/product_item_model.dart';
import 'package:ecommerce/Services/auth_services.dart';
import 'package:ecommerce/Services/product_details_services.dart';

part 'product_item_state.dart';

class ProductItemCubit extends Cubit<ProductItemState> {
  ProductItemCubit() : super(ProductItemInitial());

  productSize? selectedSize;
  int quantity = 1;
  ProductItemModel? _currentProduct; // Store the current product
  final productDetailsServices = ProductDetailsServicesImpl();
  final authServices = AuthServicesImpl();

  Future<void> getProductItem(String id) async {
    print('=== getProductItem called ===');
    print('Product ID: $id');

    emit(ProductItemLoading());
    try {
      print('Fetching product details from service...');
      final selectedProduct = await productDetailsServices.fetchProductDetails(
        id,
      );

      print('Product fetched successfully: ${selectedProduct.name}');
      print(
        'Product data: id=${selectedProduct.id}, name=${selectedProduct.name}, price=${selectedProduct.price}',
      );

      _currentProduct = selectedProduct;
      emit(ProductItemLoaded(product: selectedProduct));
    } catch (e) {
      print('ERROR fetching product: $e');
      print('Error type: ${e.runtimeType}');
      print('Stack trace: $e');

      emit(ProductItemError(message: 'Failed to load product: $e'));
    }
  }

  /// Load product directly without fetching from Firestore
  /// This is used when the product object is already available from the home page
  void loadProductDirectly(ProductItemModel product) {
    print('=== loadProductDirectly called ===');
    print('Loading product: ${product.name}');
    _currentProduct = product; // Store the product
    emit(ProductItemLoaded(product: product));
  }

  void selectSize(productSize size) {
    selectedSize = size;
    emit(SizeSelected(size: size));
  }

  Future<void> addToCart(String productId) async {
    if (selectedSize == null) {
      emit(ProductAddToCartError(errorMessage: 'Please select a size.'));
      return;
    }

    emit(ProductAddingToCart());
    try {
      print('=== Adding to cart ===');
      print('Product ID: $productId');
      print('Selected Size: ${selectedSize?.name}');
      print('Quantity: $quantity');

      // Use the currently loaded product instead of fetching again
      if (_currentProduct == null) {
        print('ERROR: Current product is null, trying to fetch...');
        _currentProduct = await productDetailsServices.fetchProductDetails(
          productId,
        );
      }

      final currentUser = authServices.currentUser();

      if (currentUser == null) {
        print('ERROR: User not logged in');
        emit(ProductAddToCartError(errorMessage: 'User not logged in.'));
        return;
      }

      print('User ID: ${currentUser.uid}');

      final cartItem = AddToCartModel(
        id: DateTime.now().toIso8601String(),
        product: _currentProduct!,
        size: selectedSize!,
        quantity: quantity,
      );

      print('Adding cart item: ${cartItem.id}');
      await productDetailsServices.addToCart(cartItem, currentUser.uid);

      print('Item added to cart successfully');
      emit(ProductAddedToCart(productId: productId));
    } catch (e) {
      print('ERROR adding to cart: $e');
      print('Stack trace: $e');
      emit(ProductAddToCartError(errorMessage: 'Failed to add to cart: $e'));
    }
  }

  void incrementCounter(String productId) {
    quantity++;
    print('Quantity incremented to: $quantity');
    emit(CounterQuantityLoaded(value: quantity));
  }

  void decrementCounter(String productId) {
    if (quantity > 1) {
      quantity--;
      print('Quantity decremented to: $quantity');
    }
    emit(CounterQuantityLoaded(value: quantity));
  }

  void resetSelection() {
    selectedSize = null;
    quantity = 1;
    emit(CounterQuantityLoaded(value: quantity));
  }
}
