/// Custom Exceptions thrown at the Data Layer.
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'A server error occurred.']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([
    this.message = 'Failed to load or save local storage data.',
  ]);
}

class GameLogicException implements Exception {
  final String message;
  const GameLogicException([
    this.message = 'Invalid game state or illegal move operation.',
  ]);
}
