import 'package:flutter_movies_app/constants/strings.dart';
import 'package:flutter_movies_app/data/repository/favorites_storage_interface.dart';
import 'package:flutter_movies_app/models/movie.dart';
import 'package:hive/hive.dart';

class HiveFavoritesStorage implements FavoritesStorageInterface {
  late Box<Map<dynamic, dynamic>> _favoritesBox;

  @override
  Future<void> initialize() async {
    try {
      if (Hive.isBoxOpen(Strings.prefFavoritesBox)) {
        _favoritesBox = Hive.box<Map>(Strings.prefFavoritesBox);
      } else {
        _favoritesBox = await Hive.openBox<Map>(Strings.prefFavoritesBox);
      }
    } catch (e) {
      // If there's an error, try to delete and recreate the box
      await Hive.deleteBoxFromDisk(Strings.prefFavoritesBox);
      _favoritesBox = await Hive.openBox<Map>(Strings.prefFavoritesBox);
    }
  }

  @override
  Future<List<Movie>> getFavorites() async {
    return _favoritesBox.values.map((favoriteMap) => Movie.fromJson(Map<String, dynamic>.from(favoriteMap))).toList();
  }

  @override
  Future<bool> isFavorite(int movieId) async {
    return _favoritesBox.containsKey(movieId.toString());
  }

  @override
  Future<void> addFavorite(Movie movie) async {
    await _favoritesBox.put(movie.id.toString(), movie.toJson());
  }

  @override
  Future<void> removeFavorite(int movieId) async {
    await _favoritesBox.delete(movieId.toString());
  }

  @override
  Future<void> close() async {
    await _favoritesBox.close();
  }
}
