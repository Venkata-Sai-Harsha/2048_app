import 'package:flutter_test/flutter_test.dart';
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
    final fakeRepo = FakeGameRepository();
    final getHighScoreUseCase = GetHighScoreUseCase(fakeRepo);
    final saveHighScoreUseCase = SaveHighScoreUseCase(fakeRepo);

    await tester.pumpWidget(
      MyApp(
        getHighScoreUseCase: getHighScoreUseCase,
        saveHighScoreUseCase: saveHighScoreUseCase,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('2048'), findsOneWidget);
  });
}
