class ImageUtils {
  static const String baseImageUrl = "http://image.tmdb.org/t/p";
  static const String basePosterLargeUrl = "$baseImageUrl/w342";
  static const String baseBackdropSmallUrl = "$baseImageUrl/w780";

  static String getLargePosterUrl(String posterPath) {
    return basePosterLargeUrl + posterPath;
  }

  static String getSmallBackdropUrl(String backdropPath) {
    return baseBackdropSmallUrl + backdropPath;
  }
}
