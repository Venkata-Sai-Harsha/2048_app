import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/features/game/domain/entities/board.dart';
import 'package:my_app/features/game/domain/usecases/get_high_score_usecase.dart';
import 'package:my_app/features/game/domain/usecases/save_high_score_usecase.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GetHighScoreUseCase getHighScoreUseCase;
  final SaveHighScoreUseCase saveHighScoreUseCase;

  GameBloc({
    required this.getHighScoreUseCase,
    required this.saveHighScoreUseCase,
  }) : super(const GameInitial()) {
    on<InitGameEvent>(_onInitGame);
    on<MoveBoardEvent>(_onMoveBoard);
    on<RestartGameEvent>(_onRestartGame);
    on<UndoMoveEvent>(_onUndoMove);
  }

  Future<void> _onInitGame(InitGameEvent event, Emitter<GameState> emit) async {
    emit(const GameLoading());
    try {
      final highScore = await getHighScoreUseCase();
      final board = Board.initial(highScore: highScore);
      emit(GameLoaded(board: board));
    } catch (e) {
      emit(GameErrorState('Failed to initialize game: $e'));
    }
  }

  Future<void> _onMoveBoard(
    MoveBoardEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameLoaded) return;

    final currentState = state as GameLoaded;
    final currentBoard = currentState.board;

    if (currentBoard.isGameOver) return;

    final updatedBoard = currentBoard.move(event.direction);

    // If board didn't change, do nothing
    if (updatedBoard == currentBoard) return;

    // Save high score if updated
    if (updatedBoard.highScore > currentBoard.highScore) {
      await saveHighScoreUseCase(updatedBoard.highScore);
    }

    if (updatedBoard.isGameOver) {
      emit(GameOverState(updatedBoard));
    } else {
      emit(GameLoaded(board: updatedBoard, previousBoard: currentBoard));
    }
  }

  Future<void> _onRestartGame(
    RestartGameEvent event,
    Emitter<GameState> emit,
  ) async {
    int highScore = 0;
    if (state is GameLoaded) {
      highScore = (state as GameLoaded).board.highScore;
    } else if (state is GameOverState) {
      highScore = (state as GameOverState).board.highScore;
    } else {
      highScore = await getHighScoreUseCase();
    }

    final newBoard = Board.initial(highScore: highScore);
    emit(GameLoaded(board: newBoard));
  }

  void _onUndoMove(UndoMoveEvent event, Emitter<GameState> emit) {
    if (state is GameLoaded) {
      final currentState = state as GameLoaded;
      if (currentState.previousBoard != null) {
        emit(GameLoaded(board: currentState.previousBoard!));
      }
    }
  }
}
