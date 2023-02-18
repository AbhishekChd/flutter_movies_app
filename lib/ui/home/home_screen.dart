import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movies_app/common_widgets/common_widgets.dart';
import 'package:flutter_movies_app/config/config.dart';
import 'package:flutter_movies_app/constants/strings.dart';
import 'package:flutter_movies_app/data/network/tmdb_api.dart';
import 'package:flutter_movies_app/models/models.dart';
import 'package:flutter_movies_app/utils/image_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> movies = [];

  _HomeScreenState() {
    String apiKey = box.get(Strings.prefApiKey, defaultValue: "");

    final tmdbClient = TMDBClient(Dio());
    tmdbClient.getMoviesByCriteria("popular", apiKey).then((TmdbResponse value) {
      if (kDebugMode) {
        print(value.toJson());
      }
      setState(() {
        movies = value.movies!;
      });
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.49,
          mainAxisSpacing: 16,
          crossAxisSpacing: 4,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return MovieCard(
            name: movies[index].title,
            rating: movies[index].rating / 2,
            imageUrl: ImageUtils.getLargePosterUrl(movies[index].posterPath),
          );
        },
      ),
    );
  }
}
