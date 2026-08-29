import 'package:equatable/equatable.dart';
import 'package:my_app/features/game/domain/entities/board.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  const GameInitial();
}

class GameLoading extends GameState {
  const GameLoading();
}

class GameLoaded extends GameState {
  final Board board;
  final Board? previousBoard;

  const GameLoaded({required this.board, this.previousBoard});

  bool get canUndo => previousBoard != null;

  @override
  List<Object?> get props => [board, previousBoard];
}

class GameOverState extends GameState {
  final Board board;
  final Board? previousBoard;

  const GameOverState(this.board, {this.previousBoard});

  bool get canUndo => previousBoard != null;

  @override
  List<Object?> get props => [board, previousBoard];
}

class GameErrorState extends GameState {
  final String message;

  const GameErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
