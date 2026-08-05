import 'package:equatable/equatable.dart';

/// Entity representing a single tile on the 2048 game board.
class Tile extends Equatable {
  final String id;
  final int value;
  final int row;
  final int col;
  final bool isNew;
  final bool isMerged;

  const Tile({
    required this.id,
    required this.value,
    required this.row,
    required this.col,
    this.isNew = false,
    this.isMerged = false,
  });

  Tile copyWith({
    String? id,
    int? value,
    int? row,
    int? col,
    bool? isNew,
    bool? isMerged,
  }) {
    return Tile(
      id: id ?? this.id,
      value: value ?? this.value,
      row: row ?? this.row,
      col: col ?? this.col,
      isNew: isNew ?? this.isNew,
      isMerged: isMerged ?? this.isMerged,
    );
  }

  @override
  List<Object?> get props => [id, value, row, col, isNew, isMerged];
}
