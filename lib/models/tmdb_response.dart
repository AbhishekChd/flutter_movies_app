import 'package:json_annotation/json_annotation.dart';
import 'movie.dart';

part 'tmdb_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TmdbResponse {
  int page;
  int totalResults;
  int totalPages;

  @JsonKey(name: "results")
  List<Movie>? movies;

  TmdbResponse(this.page, this.totalResults, this.totalPages, this.movies);

  factory TmdbResponse.fromJson(Map<String, dynamic> json) => _$TmdbResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TmdbResponseToJson(this);
}
