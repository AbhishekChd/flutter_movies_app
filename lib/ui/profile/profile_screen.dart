import 'package:flutter/material.dart';
import 'package:flutter_movies_app/config/config.dart';
import 'package:flutter_movies_app/constants/strings.dart';
import 'package:settings_ui/settings_ui.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _settingsMargin = const EdgeInsetsDirectional.all(8);

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          margin: _settingsMargin,
          title: Text(Strings.settingTitleGeneral, style: Theme.of(context).textTheme.labelLarge),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: const Icon(Icons.key),
              title: const Text(Strings.settingItemApiKey),
              value: const Text(Strings.settingItemApiKeyDefault),
              onPressed: (context) {},
            ),
          ],
        ),
        SettingsSection(
          margin: _settingsMargin,
          title: Text(Strings.settingTitleDarkMode, style: Theme.of(context).textTheme.labelLarge),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text(Strings.settingItemThemeSystem),
              initialValue: currentTheme.isSystemDefault(),
              onToggle: (bool value) => setState(() => currentTheme.switchToSystemMode()),
            ),
            SettingsTile.switchTile(
              leading: const Icon(Icons.dark_mode_outlined),
              title: const Text(Strings.settingTitleDarkMode),
              initialValue: currentTheme.isDark(),
              enabled: !currentTheme.isSystemDefault(),
              onToggle: (bool value) => setState(() => currentTheme.switchThemeMode()),
            ),
          ],
        ),
      ],
    );
  }
}
