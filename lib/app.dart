import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

class GgpenAngoticApp extends StatelessWidget {
  const GgpenAngoticApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GGPEN · Angotic 2026',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(),
      home: const SplashScreen(),
    );
  }
}
