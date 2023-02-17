import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_movies_app/common_widgets/common_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.5,
          mainAxisSpacing: 16,
          crossAxisSpacing: 4,
        ),
        itemCount: 10,
        itemBuilder: (context, index) => _getRandomMovieCard(),
      ),
    );
  }

  // todo: Remove random movie generator
  MovieCard _getRandomMovieCard() {
    const movies = [
      MovieCard(name: "The Dark Knight", genres: ["Adventure", "Fight"], rating: 3.8),
      MovieCard(
        name: "We're the Millers",
        genres: ["Comedy", "Crime"],
        rating: 3.5,
        imageUrl: "https://m.media-amazon.com/images/M/MV5BMjA5Njc0NDUxNV5BMl5BanBnXkFtZTcwMjYzNzU1OQ@@._V1_.jpg",
      ),
      MovieCard(
        name: "Suits",
        genres: ["Comedy", "Drama", "Legal Drama"],
        rating: 4.25,
        imageUrl: "https://movieposters2.com/images/1479906-b.jpg",
      ),
    ];
    int index = Random().nextInt(3);
    return movies[index];
  }
}
