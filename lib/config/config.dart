library config.globals;

import 'package:flutter_movies_app/config/prefs.dart';
import 'package:flutter_movies_app/constants/strings.dart';
import 'package:hive/hive.dart';

/// Using [Box] to store preferences in storage
Box box = Hive.box(Strings.appPreferencesName);

/// Global system preferences to maintain Theme and other settings
SystemPreferences preferences = SystemPreferences();
