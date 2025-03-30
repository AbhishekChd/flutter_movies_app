import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movies_app/common_widgets/common_widgets.dart';
import 'package:flutter_movies_app/models/movie.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    Key? key,
    required this.name,
    required this.rating,
    this.genres = const [],
    this.imageUrl = "https://m.media-amazon.com/images/I/81CLFQwU-WL._SY741_.jpg", // todo: Remove default image
    this.onTap,
    required this.movieId,
    required this.movie,
  }) : super(key: key);

  final String name;
  final double rating;
  final String imageUrl;
  final List<String> genres;
  final cardRadiusTop = const Radius.circular(12);
  final cardRadiusBottom = const Radius.circular(6);
  final VoidCallback? onTap;
  final int movieId;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: BorderRadius.all(cardRadiusTop),
      ),
      child: Stack(
        children: [
          // Main card content
          InkWell(
            onTap: onTap,
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: "hero-image-$name",
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: cardRadiusTop,
                      topRight: cardRadiusTop,
                      bottomLeft: cardRadiusBottom,
                      bottomRight: cardRadiusBottom,
                    ),
                    child: AspectRatio(
                      aspectRatio: 2 / 3,
                      child: Image(image: CachedNetworkImageProvider(imageUrl), fit: BoxFit.fill),
                    ),
                  ),
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

          // Favorite button
          Positioned(
            top: 8,
            right: 8,
            child: FavoriteButton(
              movie: movie,
              style: FavoriteButtonStyle.card,
            ),
          ),
        ],
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
