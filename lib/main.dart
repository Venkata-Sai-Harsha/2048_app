import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/services/audio_haptic_service.dart';
import 'core/theme/app_theme.dart';
import 'features/game/data/datasources/game_local_data_source.dart';
import 'features/game/data/repositories/game_repository_impl.dart';
import 'features/game/domain/usecases/get_high_score_usecase.dart';
import 'features/game/domain/usecases/save_high_score_usecase.dart';
import 'features/game/presentation/bloc/game_bloc.dart';
import 'features/game/presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final audioHapticService = AudioHapticService(sharedPreferences);

  final localDataSource =
      GameLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  final repository = GameRepositoryImpl(localDataSource: localDataSource);

  final getHighScoreUseCase = GetHighScoreUseCase(repository);
  final saveHighScoreUseCase = SaveHighScoreUseCase(repository);

  runApp(MyApp(
    audioHapticService: audioHapticService,
    getHighScoreUseCase: getHighScoreUseCase,
    saveHighScoreUseCase: saveHighScoreUseCase,
  ));
}

class MyApp extends StatelessWidget {
  final AudioHapticService audioHapticService;
  final GetHighScoreUseCase getHighScoreUseCase;
  final SaveHighScoreUseCase saveHighScoreUseCase;

  const MyApp({
    super.key,
    required this.audioHapticService,
    required this.getHighScoreUseCase,
    required this.saveHighScoreUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AudioHapticService>.value(
      value: audioHapticService,
      child: BlocProvider<GameBloc>(
        create: (context) => GameBloc(
          getHighScoreUseCase: getHighScoreUseCase,
          saveHighScoreUseCase: saveHighScoreUseCase,
        ),
        child: MaterialApp(
          title: '2048 Game',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const SplashPage(),
        ),
      ),
    );
  }
}
