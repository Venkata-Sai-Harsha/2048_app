import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:my_app/core/services/audio_haptic_service.dart';
import 'package:my_app/core/theme/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _soundEnabled;
  late bool _vibrationEnabled;
  String _appVersion = 'Loading...';

  @override
  void initState() {
    super.initState();
    final service = context.read<AudioHapticService>();
    _soundEnabled = service.isSoundEnabled;
    _vibrationEnabled = service.isVibrationEnabled;
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _appVersion = '1.0.0+1';
        });
      }
    }
  }

  void _onSoundChanged(bool val) {
    setState(() {
      _soundEnabled = val;
    });
    context.read<AudioHapticService>().setSoundEnabled(val);
  }

  void _onVibrationChanged(bool val) {
    setState(() {
      _vibrationEnabled = val;
    });
    context.read<AudioHapticService>().setVibrationEnabled(val);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Sound Effects'),
            value: _soundEnabled,
            activeThumbColor: AppColors.buttonBackground,
            onChanged: _onSoundChanged,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Haptic Vibration'),
            value: _vibrationEnabled,
            activeThumbColor: AppColors.buttonBackground,
            onChanged: _onVibrationChanged,
          ),
          const Divider(),
          ListTile(
            title: const Text('Version'),
            trailing: Text(
              _appVersion,
              style: const TextStyle(color: AppColors.darkText),
            ),
          ),
        ],
      ),
    );
  }
}
