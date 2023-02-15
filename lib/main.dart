import 'package:flutter/material.dart';
import 'package:flutter_movies_app/config/theme.dart';
import 'package:flutter_movies_app/constants/strings.dart';

void main() {
  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.appName),
        ),
        body: const Placeholder(),
      ),
    );
  }
}
