import 'package:flutter_movies_app/models/movie.dart';

/// Interface for any storage implementation that can store and retrieve favorite movies
abstract class FavoritesStorageInterface {
  /// Initialize the storage
  Future<void> initialize();

  /// Get all favorite movies
  Future<List<Movie>> getFavorites();

  /// Check if a movie is marked as favorite
  Future<bool> isFavorite(int movieId);

  /// Add a movie to favorites
  Future<void> addFavorite(Movie movie);

  /// Remove a movie from favorites
  Future<void> removeFavorite(int movieId);

  /// Close/cleanup the storage
  Future<void> close();
}
