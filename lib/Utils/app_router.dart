import 'package:ecommerce/Models/product_item_model.dart';
import 'package:ecommerce/Utils/app_routes.dart';
import 'package:ecommerce/View_Models/auth_cubit/auth_cubit.dart';
import 'package:ecommerce/View_Models/choose_location_cubit/choose_location_cubit.dart';
import 'package:ecommerce/View_Models/payment_methods_cubit/Payment_methods_cubit.dart';
import 'package:ecommerce/View_Models/product_item_cubit/product_item_cubit.dart';
import 'package:ecommerce/Views/Pages/add_new_card_page.dart';
import 'package:ecommerce/Views/Pages/checkout_page.dart';
import 'package:ecommerce/Views/Pages/choose_location_page.dart';
import 'package:ecommerce/Views/Pages/custom_bottom_navbar.dart';
import 'package:ecommerce/Views/Pages/login_page.dart';
import 'package:ecommerce/Views/Pages/product_item_page.dart';
import 'package:ecommerce/Views/Pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.homeRoute:
        return MaterialPageRoute(builder: (_) => const CustomBottomNavbar());
      case AppRoutes.loginRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(),
            child: const LoginPage(),
          ),
        );
      case AppRoutes.registerRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(),
            child: const RegisterPage(),
          ),
        );
      case AppRoutes.checkOutRoute:
        return MaterialPageRoute(builder: (_) => const CheckOutPage());
      case AppRoutes.chooseLocationRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = ChooseLocationCubit();
              cubit.fetchLocations();
              return cubit;
            },
            child: const ChooseLocationPage(),
          ),
        );
      case AppRoutes.addNewCardRoute:
        final paymentCubit = settings.arguments as PaymentMethodsCubit;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: paymentCubit,
            child: const AddNewCardPage(),
          ),
        );
      case AppRoutes.productItemRoute:
        // Now receives ProductItemModel instead of just String
        final ProductItemModel product = settings.arguments as ProductItemModel;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = ProductItemCubit();
              // Load product directly without fetching from Firestore
              cubit.loadProductDirectly(product);
              return cubit;
            },
            child: ProductItemPage(productId: product.id, product: product),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No Page With This Name Found')),
          ),
        );
    }
  }
}
