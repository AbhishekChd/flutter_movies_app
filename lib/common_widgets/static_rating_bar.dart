import 'package:flutter/material.dart';
import 'package:flutter_movies_app/config/theme.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class StaticRatingBar extends StatelessWidget {
  const StaticRatingBar({Key? key, required this.itemSize, required this.rating}) : super(key: key);

  final double itemSize;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      itemSize: itemSize,
      allowHalfRating: true,
      ratingWidget: RatingWidget(
          full: Icon(Icons.star_rounded, color: AppTheme.rating(context)),
          half: Icon(Icons.star_half_rounded, color: AppTheme.rating(context)),
          empty: Icon(Icons.star_outline_rounded, color: AppTheme.rating(context))),
      onRatingUpdate: (value) {},
      ignoreGestures: true,
      initialRating: rating,
    );
  }
}
