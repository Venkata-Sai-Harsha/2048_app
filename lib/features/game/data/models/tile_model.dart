import 'package:my_app/features/game/domain/entities/tile.dart';

/// Data model for [Tile] with JSON serialization capabilities.
class TileModel extends Tile {
  const TileModel({
    required super.id,
    required super.value,
    required super.row,
    required super.col,
    super.isNew = false,
    super.isMerged = false,
  });

  /// Factory constructor to deserialize JSON into a [TileModel].
  factory TileModel.fromJson(Map<String, dynamic> json) {
    return TileModel(
      id: json['id'] as String,
      value: json['value'] as int,
      row: json['row'] as int,
      col: json['col'] as int,
      isNew: json['isNew'] as bool? ?? false,
      isMerged: json['isMerged'] as bool? ?? false,
    );
  }

  /// Converts this [TileModel] into a JSON Map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'row': row,
      'col': col,
      'isNew': isNew,
      'isMerged': isMerged,
    };
  }

  /// Creates a [TileModel] from a [Tile] domain entity.
  factory TileModel.fromEntity(Tile entity) {
    return TileModel(
      id: entity.id,
      value: entity.value,
      row: entity.row,
      col: entity.col,
      isNew: entity.isNew,
      isMerged: entity.isMerged,
    );
  }

  /// Converts this model to a pure [Tile] domain entity.
  Tile toEntity() {
    return Tile(
      id: id,
      value: value,
      row: row,
      col: col,
      isNew: isNew,
      isMerged: isMerged,
    );
  }
}
