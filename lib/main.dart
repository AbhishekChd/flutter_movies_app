import 'package:flutter/material.dart';
import 'package:flutter_movies_app/config/theme.dart';
import 'package:flutter_movies_app/constants/strings.dart';
import 'package:flutter_movies_app/ui/screens.dart';

void main() {
  runApp(const MoviesApp());
}

class MoviesApp extends StatefulWidget {
  const MoviesApp({super.key});

  @override
  State<MoviesApp> createState() => _MoviesAppState();
}

class _MoviesAppState extends State<MoviesApp> {
  int _selectedIndex = 0;
  final _page = const [HomeScreen(), FavouritesScreen(), WatchlistScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.appName),
        ),
        body: _page[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (value) => setState(() => _selectedIndex = value),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: Strings.bottomNavHome),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: Strings.bottomNavFavourites),
            BottomNavigationBarItem(icon: Icon(Icons.horizontal_split_rounded), label: Strings.bottomNavWatchlist),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: Strings.bottomNavProfile),
          ],
        ),
      ),
    );
  }
}
