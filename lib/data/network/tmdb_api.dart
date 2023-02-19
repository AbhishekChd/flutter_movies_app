import 'package:dio/dio.dart';
import 'package:flutter_movies_app/models/models.dart';
import 'package:retrofit/retrofit.dart';

part 'tmdb_api.g.dart';

class TMDB {
  static const String movieByCriteria = 'movie/{criteria}';
  static const String movieGenres = 'genre/movie/list';
}

@RestApi(baseUrl: "https://api.themoviedb.org/3/")
abstract class TMDBClient {
  factory TMDBClient(Dio dio) = _TMDBClient;

  @GET(TMDB.movieByCriteria)
  Future<TmdbResponse> getMoviesByCriteria(
    @Path("criteria") MovieSortingCriteria criteria,
    @Query("api_key") String apiKey,
  );

  @GET(TMDB.movieGenres)
  Future<GenreResponse> getGenres(@Query("api_key") String apiKey);
}

enum MovieSortingCriteria {
  popular("popular"),
  topRated("top_rated");

  final String name;

  const MovieSortingCriteria(this.name);
}
