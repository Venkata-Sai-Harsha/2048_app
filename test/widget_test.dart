import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/core/services/audio_haptic_service.dart';
import 'package:my_app/features/game/domain/repositories/game_repository.dart';
import 'package:my_app/features/game/domain/usecases/get_high_score_usecase.dart';
import 'package:my_app/features/game/domain/usecases/save_high_score_usecase.dart';
import 'package:my_app/main.dart';

class FakeGameRepository implements GameRepository {
  int _score = 0;

  @override
  Future<int> getHighScore() async => _score;

  @override
  Future<void> saveHighScore(int score) async {
    _score = score;
  }
}

void main() {
  testWidgets('2048 App loads splash screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final audioHapticService = AudioHapticService(prefs);

    final fakeRepo = FakeGameRepository();
    final getHighScoreUseCase = GetHighScoreUseCase(fakeRepo);
    final saveHighScoreUseCase = SaveHighScoreUseCase(fakeRepo);

    await tester.pumpWidget(
      MyApp(
        audioHapticService: audioHapticService,
        getHighScoreUseCase: getHighScoreUseCase,
        saveHighScoreUseCase: saveHighScoreUseCase,
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('2048'), findsWidgets);
  });
}
