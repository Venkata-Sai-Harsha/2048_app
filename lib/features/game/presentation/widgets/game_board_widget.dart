import 'package:flutter/material.dart';
import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/features/game/domain/entities/board.dart';
import 'tile_widget.dart';

/// Renders the 4x4 grid board and tile items.
class GameBoardWidget extends StatelessWidget {
  final Board board;
  final double boardSize;

  const GameBoardWidget({
    super.key,
    required this.board,
    required this.boardSize,
  });

  @override
  Widget build(BuildContext context) {
    const double padding = 12.0;
    const double spacing = 10.0;
    final int gridDim = board.size;

    // Calculate individual tile dimensions
    final double tileSize =
        (boardSize - (padding * 2) - (spacing * (gridDim - 1))) / gridDim;

    return Container(
      width: boardSize,
      height: boardSize,
      padding: const EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.gridBackground,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        children: [
          // 1. Render empty grid background slots
          for (int r = 0; r < gridDim; r++)
            for (int c = 0; c < gridDim; c++)
              Positioned(
                left: c * (tileSize + spacing),
                top: r * (tileSize + spacing),
                child: Container(
                  width: tileSize,
                  height: tileSize,
                  decoration: BoxDecoration(
                    color: AppColors.emptyTileBackground,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),

          // 2. Render active tiles with animated position
          for (final tile in board.tiles)
            AnimatedPositioned(
              key: ValueKey(tile.id),
              duration: AppDimensions.tileMoveDuration,
              curve: Curves.easeInOutCubic,
              left: tile.col * (tileSize + spacing),
              top: tile.row * (tileSize + spacing),
              child: TileWidget(tile: tile, tileSize: tileSize),
            ),
        ],
      ),
    );
  }
}
