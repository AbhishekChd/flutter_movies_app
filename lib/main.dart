import 'package:flutter/material.dart';
import 'package:flutter_movies_app/config/config.dart';
import 'package:flutter_movies_app/config/theme.dart';
import 'package:flutter_movies_app/constants/strings.dart';
import 'package:flutter_movies_app/ui/screens.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  box = await Hive.openBox("theme");
  runApp(const Application());
}

/// Entry for our flutter app is through [Application] for the [MoviesApp] which
/// is provided by [MovieAppProvider]
///
/// [Application] and [MovieAppProvider] is separated since [ChangeNotifierProvider]
/// and [Provider] context can't be same hence need to be in different widgets
class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ModelTheme>(
      create: (context) => currentTheme,
      child: const MovieAppProvider(),
    );
  }
}

/// [MovieAppProvider] and [MoviesApp] are under different widgets since [Provider] can't
/// be called under [StatefulWidget.setState] due to `async` operation
class MovieAppProvider extends StatelessWidget {
  const MovieAppProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModelTheme theme = Provider.of<ModelTheme>(context);
    return MaterialApp(
      title: Strings.appName,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: theme.currentTheme(),
      home: const MoviesApp(),
    );
  }
}

class MoviesApp extends StatefulWidget {
  const MoviesApp({super.key});

  @override
  State<MoviesApp> createState() => _MoviesAppState();
}

class _MoviesAppState extends State<MoviesApp> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appName),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [HomeScreen(), FavouritesScreen(), WatchlistScreen(), ProfileScreen()],
      ),
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
    );
  }
}
