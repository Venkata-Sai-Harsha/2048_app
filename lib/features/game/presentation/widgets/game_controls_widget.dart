import 'package:flutter/material.dart';
import 'package:my_app/core/theme/app_colors.dart';

/// Renders Undo and Restart control buttons designed to match the [ScoreBoardWidget] theme.
class GameControlsWidget extends StatelessWidget {
  final bool canUndo;
  final bool isGameOver;
  final VoidCallback? onUndo;
  final VoidCallback onRestart;

  const GameControlsWidget({
    super.key,
    required this.canUndo,
    required this.isGameOver,
    required this.onUndo,
    required this.onRestart,
  });

  void _showUndoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.scaffoldBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.undo, color: AppColors.buttonBackground),
            SizedBox(width: 8),
            Text(
              'Undo Move',
              style: TextStyle(
                color: AppColors.darkText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          canUndo
              ? 'Do you want to revert your last move?'
              : 'No previous move available to undo.',
          style: const TextStyle(color: AppColors.darkText, fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.darkText),
            ),
          ),
          if (canUndo && onUndo != null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonBackground,
                foregroundColor: AppColors.lightText,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                onUndo!();
              },
              child: const Text('Undo'),
            ),
        ],
      ),
    );
  }

  void _showRestartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.scaffoldBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.refresh_rounded, color: AppColors.buttonBackground),
            SizedBox(width: 8),
            Text(
              'Restart Game',
              style: TextStyle(
                color: AppColors.darkText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to restart the game? Your current progress will be reset.',
          style: TextStyle(color: AppColors.darkText, fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.darkText),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tile64,
              foregroundColor: AppColors.lightText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              onRestart();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildControlBox(
          context: context,
          icon: Icons.undo,
          onPressed: canUndo ? onUndo : null,
          onLongPress: () => _showUndoDialog(context),
          tooltip: 'Undo Move (Long press for options)',
        ),
        const SizedBox(width: 8),
        _buildControlBox(
          context: context,
          icon: Icons.refresh_rounded,
          onPressed: onRestart,
          onLongPress: () => _showRestartDialog(context),
          isHighlighted: isGameOver,
          highlightColor: AppColors.tile2048,
          tooltip: isGameOver ? 'Game Over - Tap to Restart' : 'Restart Game (Long press for options)',
        ),
      ],
    );
  }

  Widget _buildControlBox({
    required BuildContext context,
    required IconData icon,
    required VoidCallback? onPressed,
    required VoidCallback? onLongPress,
    bool isHighlighted = false,
    Color? highlightColor,
    required String tooltip,
  }) {
    final bool isEnabled = onPressed != null;

    final Color bgColor = !isEnabled
        ? AppColors.scoreBoxBackground.withValues(alpha: 0.5)
        : isHighlighted
            ? (highlightColor ?? AppColors.tile64)
            : AppColors.buttonBackground;

    final Color textColor = isEnabled
        ? AppColors.lightText
        : AppColors.lightText.withValues(alpha: 0.4);

    return Tooltip(
      message: tooltip,
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(icon, color: textColor, size: 20)],
            ),
          ),
        ),
      ),
    );
  }
}
