import 'package:flutter_movies_app/models/movie.dart';

/// Base class for all favorites events
abstract class FavoritesEvent {}

/// Event to load all favorites
class LoadFavoritesEvent extends FavoritesEvent {}

/// Event to add a movie to favorites
class AddToFavoritesEvent extends FavoritesEvent {
  final Movie movie;

  AddToFavoritesEvent(this.movie);
}

/// Event to remove a movie from favorites
class RemoveFromFavoritesEvent extends FavoritesEvent {
  final int movieId;

  RemoveFromFavoritesEvent(this.movieId);
}

/// Event to toggle a movie's favorite status
class ToggleFavoriteEvent extends FavoritesEvent {
  final Movie movie;

  ToggleFavoriteEvent(this.movie);
}
