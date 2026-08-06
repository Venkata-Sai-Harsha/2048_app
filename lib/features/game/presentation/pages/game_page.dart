import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/features/game/domain/entities/board.dart';
import 'package:my_app/features/game/presentation/bloc/game_bloc.dart';
import 'package:my_app/features/game/presentation/bloc/game_event.dart';
import 'package:my_app/features/game/presentation/bloc/game_state.dart';
import 'package:my_app/features/game/presentation/pages/how_to_play_page.dart';
import 'package:my_app/features/game/presentation/pages/settings_page.dart';
import 'package:my_app/features/game/presentation/widgets/game_board_widget.dart';
import 'package:my_app/features/game/presentation/widgets/game_controls_widget.dart';
import 'package:my_app/features/game/presentation/widgets/score_board_widget.dart';

import 'package:my_app/core/services/audio_haptic_service.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<GameBloc>().add(const InitGameEvent());
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final bloc = context.read<GameBloc>();

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
        event.logicalKey == LogicalKeyboardKey.keyA) {
      bloc.add(const MoveBoardEvent(SwipeDirection.left));
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
        event.logicalKey == LogicalKeyboardKey.keyD) {
      bloc.add(const MoveBoardEvent(SwipeDirection.right));
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.logicalKey == LogicalKeyboardKey.keyW) {
      bloc.add(const MoveBoardEvent(SwipeDirection.up));
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.logicalKey == LogicalKeyboardKey.keyS) {
      bloc.add(const MoveBoardEvent(SwipeDirection.down));
    }
  }

  void _handleSwipe(DragEndDetails details) {
    final dx = details.velocity.pixelsPerSecond.dx;
    final dy = details.velocity.pixelsPerSecond.dy;
    const minVelocity = 100.0;

    final bloc = context.read<GameBloc>();

    if (dx.abs() > dy.abs()) {
      if (dx > minVelocity) {
        bloc.add(const MoveBoardEvent(SwipeDirection.right));
      } else if (dx < -minVelocity) {
        bloc.add(const MoveBoardEvent(SwipeDirection.left));
      }
    } else {
      if (dy > minVelocity) {
        bloc.add(const MoveBoardEvent(SwipeDirection.down));
      } else if (dy < -minVelocity) {
        bloc.add(const MoveBoardEvent(SwipeDirection.up));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              color: AppColors.darkText,
              tooltip: "Settings",
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<GameBloc, GameState>(
          listener: (context, state) {
            final audioHaptic = context.read<AudioHapticService>();
            if (state is GameLoaded) {
              if (state.previousBoard != null) {
                final merged = state.board.score > state.previousBoard!.score;
                audioHaptic.onTileMove(merged: merged);
              }
              if (state.board.isGameOver) {
                audioHaptic.onGameOver();
              }
            } else if (state is GameOverState) {
              audioHaptic.onGameOver();
            }
          },
          builder: (context, state) {
            if (state is GameLoading || state is GameInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GameErrorState) {
              return Center(child: Text(state.message));
            }

            Board? board;
            bool isGameOver = false;
            bool canUndo = false;

            if (state is GameLoaded) {
              board = state.board;
              canUndo = state.canUndo;
              isGameOver = board.isGameOver;
            } else if (state is GameOverState) {
              board = state.board;
              isGameOver = true;
              canUndo = false;
            }

            if (board == null) return const SizedBox.shrink();

            final screenSize = MediaQuery.of(context).size;
            final maxBoardWidth = screenSize.width * 0.9;
            final maxBoardHeight = screenSize.height * 0.55;
            final boardSize = maxBoardWidth < maxBoardHeight
                ? maxBoardWidth
                : maxBoardHeight;

            return GestureDetector(
              onHorizontalDragEnd: _handleSwipe,
              onVerticalDragEnd: _handleSwipe,
              behavior: HitTestBehavior.opaque,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Header: 2048 Title on Left, Scores & Controls on Right
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '2048',
                            style: TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkText,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ScoreBoardWidget(
                                score: board.score,
                                highScore: board.highScore,
                              ),
                              const SizedBox(height: 8),
                              GameControlsWidget(
                                canUndo: canUndo,
                                isGameOver: isGameOver,
                                onUndo: () => context.read<GameBloc>().add(
                                  const UndoMoveEvent(),
                                ),
                                onRestart: () => context.read<GameBloc>().add(
                                  const RestartGameEvent(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Game Board Grid with Game Over / Victory Overlay
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          GameBoardWidget(board: board, boardSize: boardSize),
                          if (isGameOver)
                            Container(
                              width: boardSize,
                              height: boardSize,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Game Over!',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkText,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      context.read<GameBloc>().add(
                                        const RestartGameEvent(),
                                      );
                                    },
                                    child: const Text('Try Again'),
                                  ),
                                ],
                              ),
                            ),
                          if (board.hasWon && !isGameOver)
                            Positioned(
                              top: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.tile2048,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  '🎉 2048 Reached!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HowToPlayPage(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.help_outline),
                            tooltip: 'How to Play',
                          ),
                          const SizedBox(width: 2),
                          // Instructions hint
                          const Text(
                            'Swipe or use Arrow Keys to join matching tiles!',
                            style: TextStyle(
                              color: AppColors.darkText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
