import 'package:flutter_movies_app/utils/image_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Movie {
  int id;
  String title;

  @JsonKey(name: "vote_average")
  double rating;

  int voteCount;

  String posterPath;

  List<int> genreIds;

  String overview;

  String releaseDate;

  Movie(
    this.id,
    this.title,
    this.rating,
    this.posterPath,
    this.genreIds,
    this.overview,
    this.releaseDate,
    this.voteCount,
  );

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);

  String getPosterImageUrl() {
    return ImageUtils.getLargePosterUrl(posterPath);
  }
}
