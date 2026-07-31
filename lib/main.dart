import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/game/presentation/pages/game_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048 Game',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const GamePage(),
    );
  }
}
