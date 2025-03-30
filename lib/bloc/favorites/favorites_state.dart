import 'package:flutter_movies_app/models/app_exception.dart';
import 'package:flutter_movies_app/models/movie.dart';

abstract class FavoritesState {}

class FavoritesInitialState extends FavoritesState {}

class FavoritesLoadingState extends FavoritesState {}

class FavoritesLoadedState extends FavoritesState {
  final List<Movie> favorites;

  FavoritesLoadedState(this.favorites);
}

class FavoritesErrorState extends FavoritesState {
  final AppException exception;
  final String message;

  FavoritesErrorState(this.exception, this.message);
}
