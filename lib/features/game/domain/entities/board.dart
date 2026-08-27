import 'dart:math';
import 'package:equatable/equatable.dart';
import 'tile.dart';

/// Directions for swiping the 2048 board.
enum SwipeDirection { up, down, left, right }

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

  /// Creates a new initial board with two random tiles spawned.
  factory Board.initial({int size = 4, int highScore = 0}) {
    Board board = Board(
      size: size,
      tiles: const [],
      score: 0,
      highScore: highScore,
    );
    board = board._spawnRandomTile();
    board = board._spawnRandomTile();
    return board;
  }

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

  /// Returns list of empty (row, col) coordinates.
  List<Point<int>> get emptyLocations {
    final currentGrid = grid;
    final locations = <Point<int>>[];
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (currentGrid[r][c] == null) {
          locations.add(Point(r, c));
        }
      }
    }
    return locations;
  }

  /// Main action: Moves and merges tiles in the given [direction].
  Board move(SwipeDirection direction) {
    if (isGameOver) return this;

    final currentGrid = grid;
    final newTiles = <Tile>[];
    int addedScore = 0;
    bool hasMovedOrMerged = false;

    // Helper to process a line of coordinates in order
    void processLine(List<Point<int>> lineCoords) {
      // Extract non-null tiles along this line
      final lineTiles = <Tile>[];
      for (final pt in lineCoords) {
        final t = currentGrid[pt.x][pt.y];
        if (t != null) {
          lineTiles.add(t);
        }
      }

      int targetIndex = 0;
      int i = 0;
      while (i < lineTiles.length) {
        final currentTile = lineTiles[i];
        final targetPt = lineCoords[targetIndex];

        // Check if merge is possible with next tile in line
        if (i + 1 < lineTiles.length &&
            lineTiles[i].value == lineTiles[i + 1].value) {
          final newValue = currentTile.value * 2;
          addedScore += newValue;

          // Merge into a tile at target position, preserving primary tile's ID for smooth slide animation
          newTiles.add(
            Tile(
              id: currentTile.id,
              value: newValue,
              row: targetPt.x,
              col: targetPt.y,
              isNew: false,
              isMerged: true,
            ),
          );

          hasMovedOrMerged = true;
          i += 2; // Skip merged tile
        } else {
          // Check if tile moved to a new position
          if (currentTile.row != targetPt.x || currentTile.col != targetPt.y) {
            hasMovedOrMerged = true;
          }

          newTiles.add(
            currentTile.copyWith(
              row: targetPt.x,
              col: targetPt.y,
              isNew: false,
              isMerged: false,
            ),
          );
          i++;
        }
        targetIndex++;
      }
    }

    // Process rows or columns based on direction
    for (int idx = 0; idx < size; idx++) {
      final lineCoords = <Point<int>>[];
      for (int pos = 0; pos < size; pos++) {
        switch (direction) {
          case SwipeDirection.left:
            lineCoords.add(Point(idx, pos));
            break;
          case SwipeDirection.right:
            lineCoords.add(Point(idx, size - 1 - pos));
            break;
          case SwipeDirection.up:
            lineCoords.add(Point(pos, idx));
            break;
          case SwipeDirection.down:
            lineCoords.add(Point(size - 1 - pos, idx));
            break;
        }
      }
      processLine(lineCoords);
    }

    // If nothing moved or merged, return current board state
    if (!hasMovedOrMerged) {
      return this;
    }

    final newScore = score + addedScore;
    final newHighScore = max(highScore, newScore);
    final winCondition = newTiles.any((tile) => tile.value >= 2048);

    Board updatedBoard = copyWith(
      tiles: newTiles,
      score: newScore,
      highScore: newHighScore,
      hasWon: hasWon || winCondition,
    );

    // Spawn a new tile after valid move
    updatedBoard = updatedBoard._spawnRandomTile();

    // Check for game over
    if (updatedBoard._checkGameOver()) {
      updatedBoard = updatedBoard.copyWith(isGameOver: true);
    }

    return updatedBoard;
  }

  /// Spawns a single tile (2 with 90% chance, 4 with 10% chance) on a random empty slot.
  Board _spawnRandomTile() {
    final emptyLocs = emptyLocations;
    if (emptyLocs.isEmpty) return this;

    final random = Random();
    final location = emptyLocs[random.nextInt(emptyLocs.length)];
    final tileValue = random.nextDouble() < 0.9 ? 2 : 4;

    final newTile = Tile(
      id: '${location.x}_${location.y}_${DateTime.now().microsecondsSinceEpoch}',
      value: tileValue,
      row: location.x,
      col: location.y,
      isNew: true,
    );

    return copyWith(tiles: [...tiles, newTile]);
  }

  /// Checks if any valid moves remain on the board.
  bool _checkGameOver() {
    if (emptyLocations.isNotEmpty) return false;

    final currentGrid = grid;
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        final current = currentGrid[r][c];
        if (current == null) return false;

        // Check right neighbor
        if (c + 1 < size && currentGrid[r][c + 1]?.value == current.value) {
          return false;
        }
        // Check down neighbor
        if (r + 1 < size && currentGrid[r + 1][c]?.value == current.value) {
          return false;
        }
      }
    }
    return true;
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
