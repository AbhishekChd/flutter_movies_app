library config.globals;

import 'package:flutter_movies_app/config/theme.dart';
import 'package:hive/hive.dart';

/// Global theme notifier to maintain theme data
ModelTheme currentTheme = ModelTheme();

/// Using [Box] to store preferences in storage
Box box = Hive.box("theme");