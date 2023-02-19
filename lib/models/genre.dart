import 'package:json_annotation/json_annotation.dart';

part 'genre.g.dart';

@JsonSerializable()
class Genre {
  int id;
  String name;

  Genre(this.id, this.name);

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);

  Map<String, dynamic> toJson() => _$GenreToJson(this);

  /// Utility to convert [List] of [Genre] to Map of [Genre.id]
  /// to [Genre.name] for easy access
  static Map<int, String> toMap(List<Genre> genres) {
    return {for (var element in genres) element.id: element.name};
  }

  /// Utility to use Map of genre as reference to build list of corresponding
  /// [Genre.name] using ids given
  static List<String> toNameList(Map<int, String> genres, List<int> ids) {
    List<String> list = [];
    for (var id in ids) {
      if (genres.containsKey(id)) {
        list.add(genres[id] ?? "");
      }
    }
    return list;
  }

  @override
  String toString() {
    return "id: $id, name: $name";
  }
}

@JsonSerializable(explicitToJson: true)
class GenreResponse {
  List<Genre> genres;

  GenreResponse(this.genres);

  factory GenreResponse.fromJson(Map<String, dynamic> json) => _$GenreResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GenreResponseToJson(this);
}
