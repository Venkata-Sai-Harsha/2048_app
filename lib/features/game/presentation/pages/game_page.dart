import 'package:flutter/material.dart';
import 'package:my_app/core/theme/app_colors.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('2048')),
      body: const Center(
        child: Text(
          '2048 Game Board',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
      ),
    );
  }
}
