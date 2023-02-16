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
        itemBuilder: (context, index) {
          return const MovieCard(
            name: "The Dark Knight",
            genres: ["Adventure", "Fight"],
            rating: 3.8,
          );
        },
      ),
    );
  }
}
