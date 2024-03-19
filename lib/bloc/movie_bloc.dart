import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_movies_app/config/config.dart';
import 'package:flutter_movies_app/data/network/tmdb_api.dart';
import 'package:flutter_movies_app/models/models.dart';

class MovieBloc {
  late StreamController<Resource<List<Movie>>> _movieListController;

  StreamSink<Resource<List<Movie>>> get movieListSink => _movieListController.sink;

  Stream<Resource<List<Movie>>> get movieListStream => _movieListController.stream;

  late StreamController<Resource<Map<int, String>>> _movieGenreController;

  StreamSink<Resource<Map<int, String>>> get movieGenreSink => _movieGenreController.sink;

  Stream<Resource<Map<int, String>>> get movieGenreStream => _movieGenreController.stream;

  final tmdbClient = TMDBClient(Dio());

  MovieBloc(MovieSortingCriteria criteria) {
    _movieListController = StreamController<Resource<List<Movie>>>();
    _movieGenreController = StreamController<Resource<Map<int, String>>>();

    fetchMovieGenres();
    fetchMovieList(criteria);
  }

  fetchMovieList(MovieSortingCriteria criteria) {
    movieListSink.add(Resource.loading("Fetching popular movies"));
    String authToken = preferences.getAuthToken();

    tmdbClient.getMoviesByCriteria(criteria, 'Bearer $authToken').then((TmdbResponse value) {
      movieListSink.add(Resource.completed(value.movies));
    }).onError((error, stackTrace) {
      movieListSink.add(Resource.error(AppException.getException(error!), error.toString()));
    });
  }

  fetchMovieGenres() {
    movieGenreSink.add(Resource.loading("Fetching movie genres"));
    String token = preferences.getAuthToken();

    tmdbClient.getGenres('Bearer $token').then((GenreResponse value) {
      movieGenreSink.add(Resource.completed(Genre.toMap(value.genres)));
    }).onError((error, stackTrace) {
      movieGenreSink.add(Resource.error(AppException.getException(error!), error.toString()));
    });
  }

  dispose() {
    _movieListController.close();
  }
}
