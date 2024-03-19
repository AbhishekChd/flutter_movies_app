import 'package:flutter/material.dart';
import 'package:flutter_movies_app/config/config.dart';
import 'package:flutter_movies_app/config/prefs.dart';
import 'package:flutter_movies_app/constants/strings.dart';
import 'package:flutter_movies_app/ui/profile/auth_token_page.dart';
import 'package:flutter_movies_app/utils/text_utils.dart';
import 'package:provider/provider.dart';
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
    SystemPreferences systemPreferences = Provider.of<SystemPreferences>(context);
    String authToken = TextUtils.minifyText(systemPreferences.getAuthToken(), 6);
    return SettingsList(
      sections: [
        SettingsSection(
          margin: _settingsMargin,
          title: Text(Strings.settingTitleGeneral, style: Theme.of(context).textTheme.labelLarge),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: const Icon(Icons.key),
              title: const Text(Strings.settingItemAuthToken),
              value: authToken.isEmpty ? const Text(Strings.settingItemAuthTokenDefault) : Text(authToken),
              onPressed: (context) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthTokenEdit()));
              },
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
              initialValue: preferences.getSystemThemeMode(),
              onToggle: (bool value) => setState(() => preferences.switchToSystemThemeMode()),
            ),
            SettingsTile.switchTile(
              leading: const Icon(Icons.dark_mode_outlined),
              title: const Text(Strings.settingTitleDarkMode),
              initialValue: preferences.getIsDarkThemeMode(),
              enabled: !preferences.getSystemThemeMode(),
              onToggle: (bool value) => setState(() => preferences.switchThemeMode()),
            ),
          ],
        ),
      ],
    );
  }
}
