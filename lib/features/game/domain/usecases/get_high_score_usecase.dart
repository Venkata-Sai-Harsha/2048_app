import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/features/game/domain/repositories/game_repository.dart';

class GetHighScoreUseCase implements UseCase<int, NoParams> {
  final GameRepository repository;

  GetHighScoreUseCase(this.repository);

  @override
  Future<int> call([NoParams? params]) async {
    return await repository.getHighScore();
  }
}
