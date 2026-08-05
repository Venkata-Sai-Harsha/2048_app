import 'package:flutter/material.dart';
import 'package:my_app/core/theme/app_colors.dart';

class HowToPlayPage extends StatelessWidget {
  const HowToPlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('How to Play')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Game Rules',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 16),
            _buildRuleItem(
              '1',
              'Swipe or use Arrow Keys (W, A, S, D) to move all tiles in that direction.',
            ),
            _buildRuleItem(
              '2',
              'When two tiles with the same number touch, they merge into one!',
            ),
            _buildRuleItem(
              '3',
              'Example: 2 + 2 = 4, 4 + 4 = 8, 8 + 8 = 16, ..., 1024 + 1024 = 2048!',
            ),
            _buildRuleItem(
              '4',
              'Get to the 2048 tile to win! Keep playing to reach higher scores.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.buttonBackground,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: AppColors.lightText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.darkText,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
