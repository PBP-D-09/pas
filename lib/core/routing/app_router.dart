import 'package:flutter/material.dart';

import '../../features/accounts/presentation/pages/accounts_page.dart';
import '../../features/catalog/presentation/pages/catalog_page.dart';
import '../../features/landing/presentation/pages/landing_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/reviews/presentation/pages/reviews_page.dart';
import 'app_routes.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final page = switch (settings.name) {
      AppRoutes.accounts => const AccountsPage(),
      AppRoutes.catalog => const CatalogPage(),
      AppRoutes.orders => const OrdersPage(),
      AppRoutes.map => const MapPage(),
      AppRoutes.reviews => const ReviewsPage(),
      _ => const LandingPage(),
    };

    return MaterialPageRoute<void>(builder: (_) => page, settings: settings);
  }
}
