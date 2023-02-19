import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_movies_app/config/config.dart';
import 'package:flutter_movies_app/data/network/tmdb_api.dart';
import 'package:flutter_movies_app/models/models.dart';

class MovieBloc {
  late StreamController<Resource<List<Movie>>> _movieListController;

  StreamSink<Resource<List<Movie>>> get movieListSink => _movieListController.sink;

  Stream<Resource<List<Movie>>> get movieListStream => _movieListController.stream;

  MovieBloc(MovieSortingCriteria criteria) {
    _movieListController = StreamController<Resource<List<Movie>>>();
    fetchMovieList(criteria);
  }

  fetchMovieList(MovieSortingCriteria criteria) {
    movieListSink.add(Resource.loading("Fetching popular movies"));

    String apiKey = preferences.getApiKey();
    final tmdbClient = TMDBClient(Dio());
    tmdbClient.getMoviesByCriteria(criteria, apiKey).then((TmdbResponse value) {
      movieListSink.add(Resource.completed(value.movies));
    }).onError((error, stackTrace) {
      movieListSink.add(Resource.error(error.toString()));
    });
  }

  dispose() {
    _movieListController.close();
  }
}
