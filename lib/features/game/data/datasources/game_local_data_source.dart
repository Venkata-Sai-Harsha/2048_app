import 'package:my_app/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class GameLocalDataSource {
  /// Gets the saved high score from local storage.
  Future<int> getHighScore();

  /// Saves the high score to local storage.
  Future<void> saveHighScore(int score);
}

class GameLocalDataSourceImpl implements GameLocalDataSource {
  static const String keyHighScore = '2048_HIGH_SCORE';

  final SharedPreferences sharedPreferences;

  GameLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<int> getHighScore() async {
    try {
      return sharedPreferences.getInt(keyHighScore) ?? 0;
    } catch (e) {
      throw CacheException('Failed to read high score from local storage: $e');
    }
  }

  @override
  Future<void> saveHighScore(int score) async {
    try {
      await sharedPreferences.setInt(keyHighScore, score);
    } catch (e) {
      throw CacheException('Failed to write high score to local storage: $e');
    }
  }
}
