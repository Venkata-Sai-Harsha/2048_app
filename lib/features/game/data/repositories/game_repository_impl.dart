import 'package:my_app/features/game/data/datasources/game_local_data_source.dart';
import 'package:my_app/features/game/domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final GameLocalDataSource localDataSource;

  GameRepositoryImpl({required this.localDataSource});

  @override
  Future<int> getHighScore() async {
    return await localDataSource.getHighScore();
  }

  @override
  Future<void> saveHighScore(int score) async {
    await localDataSource.saveHighScore(score);
  }
}
