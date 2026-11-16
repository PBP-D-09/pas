import 'package:flutter/material.dart';

import '../../features/accounts/presentation/pages/accounts_page.dart';
import '../../features/catalog/presentation/pages/catalog_page.dart';
import '../../features/landing/presentation/pages/landing_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/reviews/presentation/pages/reviews_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  static const _pages = <Widget>[
    LandingPage(),
    CatalogPage(),
    OrdersPage(),
    MapPage(),
    ReviewsPage(),
    AccountsPage(),
  ];

  static const _destinations = <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(
      icon: Icon(Icons.restaurant_menu),
      label: 'Catalog',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart),
      label: 'Orders',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
    BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Reviews'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Accounts'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: _destinations,
      ),
    );
  }
}
