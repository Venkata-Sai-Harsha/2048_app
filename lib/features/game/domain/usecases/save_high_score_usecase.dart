import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/features/game/domain/repositories/game_repository.dart';

class SaveHighScoreUseCase implements UseCase<void, int> {
  final GameRepository repository;

  SaveHighScoreUseCase(this.repository);

  @override
  Future<void> call(int newScore) async {
    final currentHighScore = await repository.getHighScore();
    if (newScore > currentHighScore) {
      await repository.saveHighScore(newScore);
    }
  }
}
