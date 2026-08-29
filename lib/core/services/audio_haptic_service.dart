import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class AudioHapticService {
  static const String _keySound = '2048_SOUND_ENABLED';
  static const String _keyVibration = '2048_VIBRATION_ENABLED';

  final SharedPreferences prefs;
  late final AudioPlayer _movePlayer;
  late final AudioPlayer _mergePlayer;

  AudioHapticService(this.prefs) {
    _movePlayer = AudioPlayer();
    _mergePlayer = AudioPlayer();
    _initAudio();
  }

  void _initAudio() async {
    try {
      await _movePlayer.setSource(AssetSource('sounds/move.wav'));
      await _mergePlayer.setSource(AssetSource('sounds/merge.wav'));
    } catch (_) {}
  }

  bool get isSoundEnabled => prefs.getBool(_keySound) ?? true;
  bool get isVibrationEnabled => prefs.getBool(_keyVibration) ?? true;

  Future<void> setSoundEnabled(bool enabled) async {
    await prefs.setBool(_keySound, enabled);
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    await prefs.setBool(_keyVibration, enabled);
  }

  void onTileMove({bool merged = false}) async {
    if (isSoundEnabled) {
      try {
        if (merged) {
          await _mergePlayer.stop();
          await _mergePlayer.play(AssetSource('sounds/merge.wav'));
        } else {
          await _movePlayer.stop();
          await _movePlayer.play(AssetSource('sounds/move.wav'));
        }
      } catch (_) {
        SystemSound.play(SystemSoundType.click);
      }
    }

    if (isVibrationEnabled) {
      _triggerVibration(durationMs: merged ? 50 : 25);
    }
  }

  void onGameOver() async {
    if (isSoundEnabled) {
      try {
        await _mergePlayer.stop();
        await _mergePlayer.play(AssetSource('sounds/merge.wav'));
      } catch (_) {
        SystemSound.play(SystemSoundType.alert);
      }
    }

    if (isVibrationEnabled) {
      _triggerVibration(durationMs: 120);
    }
  }

  void _triggerVibration({required int durationMs}) async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: durationMs);
      } else {
        HapticFeedback.vibrate();
      }
    } catch (_) {
      HapticFeedback.vibrate();
    }
  }

  void dispose() {
    _movePlayer.dispose();
    _mergePlayer.dispose();
  }
}
