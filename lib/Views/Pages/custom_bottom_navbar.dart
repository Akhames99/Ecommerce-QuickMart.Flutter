import 'package:ecommerce/Views/Pages/favorites_page.dart';
import 'package:ecommerce/Views/Pages/home_page.dart';
import 'package:ecommerce/Views/Pages/orders_page.dart';
import 'package:ecommerce/Views/Pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CustomBottomNavbar extends StatefulWidget {
  const CustomBottomNavbar({super.key});

  @override
  State<CustomBottomNavbar> createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar> {
  late final PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
  }

  @override
  Widget build(BuildContext context) {
    Widget IconNavbar(String path) {
      return Image.asset(
        path,
        height: 30,
        width: 30,
        color: Theme.of(context).primaryColor,
      );
    }

    return PersistentTabView(
      controller: _controller,
      tabs: [
        PersistentTabConfig(
          screen: HomePage(),
          item: ItemConfig(
            icon: IconNavbar('assets/icons/homeF.png'),
            activeForegroundColor: Theme.of(context).primaryColor,
            inactiveForegroundColor: Theme.of(
              context,
            ).primaryColor.withOpacity(0.15),
            inactiveIcon: Opacity(
              child: IconNavbar('assets/icons/homeO.png'),
              opacity: 0.15,
            ),
            title: "Home",
          ),
        ),
        PersistentTabConfig(
          screen: OrdersPage(),
          item: ItemConfig(
            icon: IconNavbar('assets/icons/ordersF.png'),
            activeForegroundColor: Theme.of(context).primaryColor,
            inactiveForegroundColor: Theme.of(
              context,
            ).primaryColor.withOpacity(0.15),
            inactiveIcon: Opacity(
              child: IconNavbar('assets/icons/ordersO.png'),
              opacity: 0.15,
            ),
            title: "My Orders",
          ),
        ),
        PersistentTabConfig(
          screen: FavoritesPage(),
          item: ItemConfig(
            icon: IconNavbar('assets/icons/favoriteF.png'),
            activeForegroundColor: Theme.of(context).primaryColor,
            inactiveForegroundColor: Theme.of(
              context,
            ).primaryColor.withOpacity(0.15),
            inactiveIcon: Opacity(
              child: IconNavbar('assets/icons/favoriteO.png'),
              opacity: 0.15,
            ),
            title: "Favorites",
          ),
        ),
        PersistentTabConfig(
          screen: ProfilePage(),
          item: ItemConfig(
            icon: IconNavbar('assets/icons/profileF.png'),
            activeForegroundColor: Theme.of(context).primaryColor,
            inactiveForegroundColor: Theme.of(
              context,
            ).primaryColor.withOpacity(0.15),
            inactiveIcon: Opacity(
              child: IconNavbar('assets/icons/profileO.png'),
              opacity: 0.15,
            ),
            title: "My Profile",
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) =>
          Style6BottomNavBar(navBarConfig: navBarConfig),
    );
  }
}
