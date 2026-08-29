/// Layout dimensions, paddings, and sizes used across the app.
class AppDimensions {
  // Grid & Board Dimensions
  static const int gridCrossAxisCount = 4;
  static const double boardPadding = 12.0;
  static const double tileSpacing = 8.0;
  static const double tileBorderRadius = 8.0;
  static const double boardBorderRadius = 12.0;

  // Header & Score Card Dimensions
  static const double scoreBoxPaddingHorizontal = 16.0;
  static const double scoreBoxPaddingVertical = 8.0;
  static const double scoreBoxBorderRadius = 6.0;

  // Animation Durations
  static const Duration tileAnimationDuration = Duration(milliseconds: 200);
  static const Duration tileMoveDuration = Duration(milliseconds: 200);
  static const Duration tileSpawnDuration = Duration(milliseconds: 320);
  static const Duration tileMergeDuration = Duration(milliseconds: 380);
}
