import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movies_app/common_widgets/common_widgets.dart';
import 'package:flutter_movies_app/models/models.dart';
import 'package:flutter_movies_app/utils/text_utils.dart';

class MovieDetail extends StatelessWidget {
  const MovieDetail({Key? key, required this.movie, required this.genres}) : super(key: key);

  final List<String> genres;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Details"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_outline))],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text("Add to watchlist", style: TextStyle(fontSize: 16)),
        icon: const Icon(CupertinoIcons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MovieDetailHeader(genres: genres, movie: movie),
              const SizedBox(height: 32),
              Text("Overview", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(movie.overview, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _MovieDetailHeader extends StatelessWidget {
  const _MovieDetailHeader({Key? key, required this.genres, required this.movie}) : super(key: key);

  final List<String> genres;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 342 / 2,
          child: Hero(
            tag: "hero-image-${movie.title}",
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: Image(image: CachedNetworkImageProvider(movie.getPosterImageUrl())),
              ),
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  TextUtils.genreAndReleaseFormat(genres, movie.releaseDate),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StaticRatingBar(
                      itemSize: Theme.of(context).textTheme.labelLarge!.fontSize! + 5,
                      rating: movie.rating / 2,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${TextUtils.movieRating(movie.rating)} (${movie.voteCount})",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
