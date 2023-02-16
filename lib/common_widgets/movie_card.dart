import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    Key? key,
    required this.name,
    required this.rating,
    this.genres = const [],
    this.imageUrl = "https://m.media-amazon.com/images/I/81CLFQwU-WL._SY741_.jpg", // todo: Remove default image
  }) : super(key: key);

  final String name;
  final double rating;
  final String imageUrl;
  final List<String> genres;
  final cardRadius = const Radius.circular(12);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: cardRadius, topRight: cardRadius),
              child: AspectRatio(aspectRatio: 2 / 3, child: Image(image: NetworkImage(imageUrl), fit: BoxFit.fill)),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      RatingBar(
                        itemSize: Theme.of(context).textTheme.labelLarge!.fontSize ?? 24,
                        allowHalfRating: true,
                        ratingWidget: RatingWidget(
                            full: const Icon(Icons.star_rounded, color: Colors.deepOrange),
                            half: const Icon(Icons.star_half_rounded, color: Colors.deepOrange),
                            empty: const Icon(Icons.star_outline_rounded, color: Colors.deepOrange)),
                        onRatingUpdate: (value) {},
                        ignoreGestures: true,
                        initialRating: rating,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(rating.toString(), style: Theme.of(context).textTheme.labelLarge)
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(genres.join(", "), style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 4),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
