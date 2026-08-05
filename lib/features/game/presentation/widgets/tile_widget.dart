import 'package:flutter/material.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/features/game/domain/entities/tile.dart';

/// Renders an individual 2048 tile with color mapping and size calculation.
class TileWidget extends StatelessWidget {
  final Tile tile;
  final double tileSize;

  const TileWidget({super.key, required this.tile, required this.tileSize});

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.getTileColor(tile.value);
    final textColor = AppColors.getTileTextColor(tile.value);

    // Adjust font size based on tile value magnitude
    double fontSize = tileSize * 0.45;
    if (tile.value >= 100 && tile.value < 1000) {
      fontSize = tileSize * 0.38;
    } else if (tile.value >= 1000) {
      fontSize = tileSize * 0.30;
    }

    return Container(
      width: tileSize,
      height: tileSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        '${tile.value}',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
