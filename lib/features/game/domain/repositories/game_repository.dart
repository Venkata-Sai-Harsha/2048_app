abstract class GameRepository {
  /// Fetches the highest score achieved.
  Future<int> getHighScore();

  /// Persists a new high score.
  Future<void> saveHighScore(int score);
}
