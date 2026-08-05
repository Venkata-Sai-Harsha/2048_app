import 'package:flutter/material.dart';
import 'package:my_app/core/theme/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

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
            onChanged: (val) {
              setState(() {
                _soundEnabled = val;
              });
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Haptic Vibration'),
            value: _vibrationEnabled,
            activeThumbColor: AppColors.buttonBackground,
            onChanged: (val) {
              setState(() {
                _vibrationEnabled = val;
              });
            },
          ),
          const Divider(),
          const ListTile(
            title: Text('Version'),
            trailing: Text(
              '1.0.0',
              style: TextStyle(color: AppColors.darkText),
            ),
          ),
        ],
      ),
    );
  }
}
