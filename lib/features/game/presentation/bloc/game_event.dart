import 'package:equatable/equatable.dart';
import 'package:my_app/features/game/domain/entities/board.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initialize the game and load high score.
class InitGameEvent extends GameEvent {
  const InitGameEvent();
}

/// Event triggered when user swipes or presses arrow key.
class MoveBoardEvent extends GameEvent {
  final SwipeDirection direction;

  const MoveBoardEvent(this.direction);

  @override
  List<Object?> get props => [direction];
}

/// Event to restart the current game session.
class RestartGameEvent extends GameEvent {
  const RestartGameEvent();
}

/// Event to undo the last move.
class UndoMoveEvent extends GameEvent {
  const UndoMoveEvent();
}
