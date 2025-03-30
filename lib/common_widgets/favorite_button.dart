import 'package:flutter/material.dart';
import 'package:flutter_movies_app/bloc/favorites/favorites_bloc.dart';
import 'package:flutter_movies_app/bloc/favorites/favorites_event.dart';
import 'package:flutter_movies_app/bloc/favorites/favorites_provider.dart';
import 'package:flutter_movies_app/models/movie.dart';

enum FavoriteButtonStyle {
  card, // For use on movie cards with semi-transparent background
  appBar, // For use in app bars
}

class FavoriteButton extends StatelessWidget {
  final Movie movie;
  final FavoriteButtonStyle style;
  final double size;
  final bool showBackground;

  const FavoriteButton({
    Key? key,
    required this.movie,
    this.style = FavoriteButtonStyle.card,
    this.size = 24.0,
    this.showBackground = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritesBloc = FavoritesBlocProvider.of(context);

    Widget buttonContent = StreamBuilder<bool>(
      stream: favoritesBloc.getFavoriteStatus(movie.id),
      initialData: false,
      builder: (context, snapshot) {
        final isFavorite = snapshot.data ?? false;

        return IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              isFavorite
                  ? Icons.favorite
                  : style == FavoriteButtonStyle.card
                      ? Icons.favorite_border
                      : Icons.favorite_outline,
              key: ValueKey<bool>(isFavorite),
              color: isFavorite
                  ? Colors.red
                  : style == FavoriteButtonStyle.card
                      ? Colors.white
                      : null,
              size: size,
            ),
          ),
          onPressed: () {
            favoritesBloc.favoritesEventSink.add(ToggleFavoriteEvent(movie));
          },
        );
      },
    );

    // For card style with background
    if (style == FavoriteButtonStyle.card && showBackground) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: buttonContent,
      );
    }

    return buttonContent;
  }
}
