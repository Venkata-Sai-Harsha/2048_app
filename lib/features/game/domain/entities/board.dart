import 'package:equatable/equatable.dart';
import 'tile.dart';

/// Entity representing the game board state for 2048.
class Board extends Equatable {
  final int size;
  final List<Tile> tiles;
  final int score;
  final int highScore;
  final bool isGameOver;
  final bool hasWon;

  const Board({
    this.size = 4,
    required this.tiles,
    this.score = 0,
    this.highScore = 0,
    this.isGameOver = false,
    this.hasWon = false,
  });

  /// Helper to get a 2D matrix view of tiles indexed by [row][col].
  List<List<Tile?>> get grid {
    final matrix = List.generate(size, (_) => List<Tile?>.filled(size, null));
    for (final tile in tiles) {
      if (tile.row >= 0 &&
          tile.row < size &&
          tile.col >= 0 &&
          tile.col < size) {
        matrix[tile.row][tile.col] = tile;
      }
    }
    return matrix;
  }

  Board copyWith({
    int? size,
    List<Tile>? tiles,
    int? score,
    int? highScore,
    bool? isGameOver,
    bool? hasWon,
  }) {
    return Board(
      size: size ?? this.size,
      tiles: tiles ?? this.tiles,
      score: score ?? this.score,
      highScore: highScore ?? this.highScore,
      isGameOver: isGameOver ?? this.isGameOver,
      hasWon: hasWon ?? this.hasWon,
    );
  }

  @override
  List<Object?> get props => [
    size,
    tiles,
    score,
    highScore,
    isGameOver,
    hasWon,
  ];
}
