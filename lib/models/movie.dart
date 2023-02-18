import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Movie {
  int id;
  String title;

  @JsonKey(name: "vote_average")
  double rating;

  String posterPath;

  List<int> genreIds;

  Movie(this.id, this.title, this.rating, this.posterPath, this.genreIds);

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
