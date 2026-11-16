import 'package:flutter/material.dart';

import 'core/navigation/home_shell.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

class SustainaBowlApp extends StatelessWidget {
  const SustainaBowlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SustainaBowl',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeShell(),
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
