import 'package:my_app/features/game/domain/entities/board.dart';
import 'tile_model.dart';

/// Data model for [Board] with JSON serialization capabilities.
class BoardModel extends Board {
  const BoardModel({
    super.size = 4,
    required super.tiles,
    super.score = 0,
    super.highScore = 0,
    super.isGameOver = false,
    super.hasWon = false,
  });

  /// Factory constructor to deserialize JSON into a [BoardModel].
  factory BoardModel.fromJson(Map<String, dynamic> json) {
    final rawTiles = json['tiles'] as List<dynamic>? ?? [];
    final tileModels = rawTiles
        .map((t) => TileModel.fromJson(t as Map<String, dynamic>))
        .toList();

    return BoardModel(
      size: json['size'] as int? ?? 4,
      tiles: tileModels,
      score: json['score'] as int? ?? 0,
      highScore: json['highScore'] as int? ?? 0,
      isGameOver: json['isGameOver'] as bool? ?? false,
      hasWon: json['hasWon'] as bool? ?? false,
    );
  }

  /// Converts this [BoardModel] into a JSON Map.
  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'tiles': tiles.map((t) => TileModel.fromEntity(t).toJson()).toList(),
      'score': score,
      'highScore': highScore,
      'isGameOver': isGameOver,
      'hasWon': hasWon,
    };
  }

  /// Creates a [BoardModel] from a [Board] domain entity.
  factory BoardModel.fromEntity(Board entity) {
    return BoardModel(
      size: entity.size,
      tiles: entity.tiles,
      score: entity.score,
      highScore: entity.highScore,
      isGameOver: entity.isGameOver,
      hasWon: entity.hasWon,
    );
  }

  /// Converts this model to a pure [Board] domain entity.
  Board toEntity() {
    return Board(
      size: size,
      tiles: tiles,
      score: score,
      highScore: highScore,
      isGameOver: isGameOver,
      hasWon: hasWon,
    );
  }
}
