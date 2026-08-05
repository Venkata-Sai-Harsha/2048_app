import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/features/game/presentation/bloc/game_bloc.dart';
import 'package:my_app/features/game/presentation/bloc/game_state.dart';

class HighScorePage extends StatelessWidget {
  const HighScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('High Scores')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              int highScore = 0;
              if (state is GameLoaded) {
                highScore = state.board.highScore;
              } else if (state is GameOverState) {
                highScore = state.board.highScore;
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.emoji_events_rounded,
                    size: 80,
                    color: AppColors.tile2048,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'BEST SCORE',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$highScore',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.buttonBackground,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
