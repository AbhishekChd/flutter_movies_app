import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_movies_app/bloc/favorites/favorites_event.dart';
import 'package:flutter_movies_app/bloc/favorites/favorites_provider.dart';
import 'package:flutter_movies_app/bloc/favorites/favorites_state.dart';
import 'package:flutter_movies_app/common_widgets/common_widgets.dart';
import 'package:flutter_movies_app/ui/home/movie_detail_page.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> with WidgetsBindingObserver {
  bool _needsRefresh = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadFavorites();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _needsRefresh) {
      _loadFavorites();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_needsRefresh) {
      _loadFavorites();
    }
  }

  void _loadFavorites() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load favorites when screen is shown
      final favoritesBloc = FavoritesBlocProvider.of(context);
      favoritesBloc.favoritesEventSink.add(LoadFavoritesEvent());
      _needsRefresh = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesBloc = FavoritesBlocProvider.of(context);

    return StreamBuilder<FavoritesState>(
      stream: favoritesBloc.favoritesState,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final state = snapshot.data!;

        if (state is FavoritesLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FavoritesErrorState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 80, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${state.message}',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    favoritesBloc.favoritesEventSink.add(LoadFavoritesEvent());
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        } else if (state is FavoritesLoadedState) {
          final favoriteMovies = state.favorites;

          if (favoriteMovies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    "No favorites yet",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Add movies to your favorites by tapping the heart icon",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                    child: Text(
                      "Your Favorites",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  LayoutGrid(
                    columnSizes: [1.fr, 1.fr],
                    rowSizes: List.generate((favoriteMovies.length / 2).ceil(), (int index) => auto),
                    rowGap: 16,
                    columnGap: 8,
                    children: favoriteMovies.map((movie) {
                      return MovieCard(
                        name: movie.title,
                        rating: movie.rating / 2,
                        imageUrl: movie.getPosterImageUrl(),
                        genres: const [],
                        // We don't have genres data here
                        movieId: movie.id,
                        movie: movie,
                        onTap: () {
                          _needsRefresh = true; // Set flag to refresh when we return to this screen
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MovieDetail(
                              movie: movie,
                              genres: const [], // We don't have genres data here
                            ),
                          ));
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        }

        // Default case (InitialState or unknown state)
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
