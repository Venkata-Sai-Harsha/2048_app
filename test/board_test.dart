import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/features/game/domain/entities/board.dart';
import 'package:my_app/features/game/domain/entities/tile.dart';
import 'package:my_app/features/game/presentation/bloc/game_state.dart';

void main() {
  group('Board Slide & Merge Animation Tests', () {
    test('Tile merging preserves primary tile ID for smooth sliding', () {
      const tile1 = Tile(id: 'tile_1', value: 2, row: 0, col: 1);
      const tile2 = Tile(id: 'tile_2', value: 2, row: 0, col: 3);

      const board = Board(size: 4, tiles: [tile1, tile2]);
      final movedBoard = board.move(SwipeDirection.left);

      // In moved board, tile1 and tile2 should merge at (0,0) with value 4
      expect(movedBoard.tiles.length, equals(2)); // 1 merged + 1 spawned
      final mergedTile = movedBoard.tiles.firstWhere((t) => t.isMerged);
      expect(mergedTile.id, equals('tile_1'));
      expect(mergedTile.value, equals(4));
      expect(mergedTile.row, equals(0));
      expect(mergedTile.col, equals(0));
      expect(mergedTile.isMerged, isTrue);
    });

    test('Newly spawned tile has isNew flag set to true', () {
      const tile1 = Tile(id: 'tile_1', value: 2, row: 0, col: 1);
      const board = Board(size: 4, tiles: [tile1]);
      final movedBoard = board.move(SwipeDirection.left);

      final newTile = movedBoard.tiles.firstWhere((t) => t.isNew);
      expect(newTile.isNew, isTrue);
      expect(newTile.isMerged, isFalse);
    });

    test('GameOverState allows undoing to previous board', () {
      const tile1 = Tile(id: 'tile_1', value: 2, row: 0, col: 0);
      const prevBoard = Board(size: 4, tiles: [tile1]);
      // Create a full board with no valid moves
      final fullTiles = <Tile>[];
      int val = 2;
      for (int r = 0; r < 4; r++) {
        for (int c = 0; c < 4; c++) {
          val = (val == 2) ? 4 : 2;
          fullTiles.add(Tile(id: 't_${r}_$c', value: val, row: r, col: c));
        }
      }
      final gameOverBoard = Board(size: 4, tiles: fullTiles, isGameOver: true);
      expect(gameOverBoard.isGameOver, isTrue);

      final gameOverState = GameOverState(gameOverBoard, previousBoard: prevBoard);
      expect(gameOverState.canUndo, isTrue);
      expect(gameOverState.previousBoard, equals(prevBoard));
    });
  });
}
