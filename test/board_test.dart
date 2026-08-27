import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/features/game/domain/entities/board.dart';
import 'package:my_app/features/game/domain/entities/tile.dart';

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
  });
}
