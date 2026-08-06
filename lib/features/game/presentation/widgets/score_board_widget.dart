import 'package:flutter/material.dart';
import 'package:my_app/core/theme/app_colors.dart';

/// Renders current Score and Best High Score boxes.
class ScoreBoardWidget extends StatelessWidget {
  final int score;
  final int highScore;

  const ScoreBoardWidget({
    super.key,
    required this.score,
    required this.highScore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildScoreBox('SCORE', score),
        const SizedBox(width: 12),
        _buildScoreBox('HIGH SCORE', highScore),
      ],
    );
  }

  Widget _buildScoreBox(String label, int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.scoreBoxBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.emptyTileBackground,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$value',
            style: const TextStyle(
              color: AppColors.lightText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
