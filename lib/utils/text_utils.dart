import 'dart:math';

abstract class TextUtils {
  static String minifyText(String text, int chars, {String overflow = "..."}) {
    if (text.length <= chars) {
      return text;
    }
    return text.substring(0, chars + 1) + overflow.toString();
  }

  static String genreAndReleaseFormat(List<String> genres, String releaseDate, {int genreCount = 2}) {
    genreCount = min(genreCount, genres.length);
    return "${genres.sublist(0, 2).join(", ")} | ${releaseDate.substring(0, 4)}";
  }

  static String movieRating(double rating, {int maxRating = 10, int targetRatingMax = 5}) {
    double targetRating = (rating * targetRatingMax) / maxRating;
    return targetRating.toStringAsFixed(1);
  }
}
