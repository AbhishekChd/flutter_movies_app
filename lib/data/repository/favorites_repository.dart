import 'dart:async';

import 'package:flutter_movies_app/data/repository/favorites_storage_interface.dart';
import 'package:flutter_movies_app/models/movie.dart';

/// FavoritesRepository is responsible for data operations and caching
class FavoritesRepository {
  final FavoritesStorageInterface _storage;
  final Set<int> _favoritesCache = {};
  bool _isInitialized = false;
  final Completer<void> _initCompleter = Completer<void>();

  FavoritesRepository(this._storage);

  Future<void> get initialized => _initCompleter.future;

  bool get isInitialized => _isInitialized;

  Set<int> get favoriteIds => Set.unmodifiable(_favoritesCache);

  Future<void> initialize() async {
    try {
      await _storage.initialize();
      final favorites = await _storage.getFavorites();
      _favoritesCache.clear();
      _favoritesCache.addAll(favorites.map((movie) => movie.id));
      _isInitialized = true;
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
    } catch (e) {
      if (!_initCompleter.isCompleted) {
        _initCompleter.completeError(e);
      }
      rethrow;
    }
  }

  Future<List<Movie>> getFavorites() async {
    return await _storage.getFavorites();
  }

  Future<bool> isFavorite(int movieId) async {
    if (!_isInitialized) {
      await initialized;
    }
    if (_favoritesCache.contains(movieId)) {
      return true;
    }
    return await _storage.isFavorite(movieId);
  }

  Future<void> addFavorite(Movie movie) async {
    await _storage.addFavorite(movie);
    _favoritesCache.add(movie.id);
  }

  Future<void> removeFavorite(int movieId) async {
    await _storage.removeFavorite(movieId);
    _favoritesCache.remove(movieId);
  }

  void updateCache(List<Movie> favorites) {
    _favoritesCache.clear();
    _favoritesCache.addAll(favorites.map((movie) => movie.id));
  }

  void close() {
    _storage.close();
  }
}
