import 'package:dio/dio.dart';
import 'package:flutter_movies_app/models/models.dart';
import 'package:retrofit/retrofit.dart';

part 'tmdb_api.g.dart';

class TMDB {
  static const String movieByCriteria = 'movie/{criteria}';
}

@RestApi(baseUrl: "https://api.themoviedb.org/3/")
abstract class TMDBClient {
  factory TMDBClient(Dio dio) = _TMDBClient;

  @GET(TMDB.movieByCriteria)
  Future<TmdbResponse> getMoviesByCriteria(@Path("criteria") String criteria, @Query("api_key") String apiKey);
}
