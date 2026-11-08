import 'package:flutter/material.dart';

import 'core/routing/app_router.dart';
import 'features/landing/presentation/pages/landing_page.dart';

class SustainaBowlApp extends StatelessWidget {
  const SustainaBowlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SustainaBowl',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const LandingPage(),
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
