import 'package:flutter/material.dart';

/// Centralized color palette for the 2048 Game app.
class AppColors {
  // App & Board Layout Colors
  static const Color scaffoldBackground = Color(0xFFFAF8EF);
  static const Color gridBackground = Color(0xFFBBADA0);
  static const Color emptyTileBackground = Color(0xFFCDC1B4);
  static const Color scoreBoxBackground = Color(0xFFBBADA0);
  static const Color buttonBackground = Color(0xFF8F7A66);

  // Text Colors
  static const Color darkText = Color(0xFF776E65);
  static const Color scoreLabelText = Color(0xFFEEE4DA);
  static const Color lightText = Color(0xFFF9F6F2);

  // 2048 Tile Colors
  static const Color tile2 = Color(0xFFEEE4DA);
  static const Color tile4 = Color(0xFFEDE0C8);
  static const Color tile8 = Color(0xFFF2B179);
  static const Color tile16 = Color(0xFFF59563);
  static const Color tile32 = Color(0xFFF67C5F);
  static const Color tile64 = Color(0xFFF65E3B);
  static const Color tile128 = Color(0xFFEDCF72);
  static const Color tile256 = Color(0xFFEDCC61);
  static const Color tile512 = Color(0xFFEDC850);
  static const Color tile1024 = Color(0xFFEDC53F);
  static const Color tile2048 = Color(0xFFEDC22E);
  static const Color tileSuper = Color(0xFF3C3A32); // For values > 2048

  /// Returns background color according to the tile value.
  static Color getTileColor(int value) {
    switch (value) {
      case 2:
        return tile2;
      case 4:
        return tile4;
      case 8:
        return tile8;
      case 16:
        return tile16;
      case 32:
        return tile32;
      case 64:
        return tile64;
      case 128:
        return tile128;
      case 256:
        return tile256;
      case 512:
        return tile512;
      case 1024:
        return tile1024;
      case 2048:
        return tile2048;
      default:
        return tileSuper;
    }
  }

  /// Returns font color according to the tile value (2 & 4 use dark text, 8+ use light text).
  static Color getTileTextColor(int value) {
    if (value <= 4) {
      return darkText;
    }
    return lightText;
  }
}
