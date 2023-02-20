import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_movies_app/common_widgets/common_widgets.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    Key? key,
    required this.name,
    required this.rating,
    this.genres = const [],
    this.imageUrl = "https://m.media-amazon.com/images/I/81CLFQwU-WL._SY741_.jpg", // todo: Remove default image
    this.onTap,
  }) : super(key: key);

  final String name;
  final double rating;
  final String imageUrl;
  final List<String> genres;
  final cardRadius = const Radius.circular(12);
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: BorderRadius.all(cardRadius),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: cardRadius, topRight: cardRadius),
              child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Hero(tag: "hero-image-$name", child: Image(image: NetworkImage(imageUrl), fit: BoxFit.fill))),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: _getTitleHeight(context),
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      StaticRatingBar(
                        itemSize: Theme.of(context).textTheme.labelLarge!.fontSize!,
                        rating: rating,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(rating.toStringAsFixed(1), style: Theme.of(context).textTheme.labelLarge)
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(_extractTopGenres(), style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 4),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _extractTopGenres({int count = 2}) => genres.sublist(0, min(genres.length, count)).join(", ");

  double _getTitleHeight(BuildContext context) {
    double height = Theme.of(context).textTheme.titleMedium!.height ?? 1;
    double fontSize = Theme.of(context).textTheme.titleMedium!.fontSize ?? 1;
    double titleTextHeight = max(height * fontSize * 1.8, 24);
    return titleTextHeight;
  }
}
