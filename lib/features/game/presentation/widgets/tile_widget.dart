import 'package:flutter/material.dart';
import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/features/game/domain/entities/tile.dart';

/// Renders an individual 2048 tile with scale spawn animation, merge pop animation, and color transitions.
class TileWidget extends StatefulWidget {
  final Tile tile;
  final double tileSize;

  const TileWidget({super.key, required this.tile, required this.tileSize});

  @override
  State<TileWidget> createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDimensions.tileSpawnDuration,
    );
    _setupAnimation();
  }

  @override
  void didUpdateWidget(covariant TileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tile.isMerged && !oldWidget.tile.isMerged) {
      _triggerMergePop();
    } else if (widget.tile.value != oldWidget.tile.value) {
      _triggerMergePop();
    }
  }

  void _setupAnimation() {
    if (widget.tile.isNew) {
      _controller.duration = AppDimensions.tileSpawnDuration;
      _scaleAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      _controller.forward(from: 0.0);
    } else {
      _scaleAnimation = const AlwaysStoppedAnimation(1.0);
    }
  }

  void _triggerMergePop() {
    _scaleAnimation = const AlwaysStoppedAnimation(1.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.getTileColor(widget.tile.value);
    final textColor = AppColors.getTileTextColor(widget.tile.value);

    // Adjust font size based on tile value magnitude
    double fontSize = widget.tileSize * 0.45;
    if (widget.tile.value >= 100 && widget.tile.value < 1000) {
      fontSize = widget.tileSize * 0.38;
    } else if (widget.tile.value >= 1000) {
      fontSize = widget.tileSize * 0.30;
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: widget.tileSize,
        height: widget.tileSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          '${widget.tile.value}',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
